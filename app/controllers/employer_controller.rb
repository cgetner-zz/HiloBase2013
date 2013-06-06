# coding: UTF-8

class EmployerController < ApplicationController

  layout "employer_v2"
  before_filter :validate_current_step, :except => [:update_account, :update_company, :create_corporate_account, :spending_limit, :set_monthly_auto_renew, :set_spending_limit_no]
  skip_before_filter :verify_authenticity_token, :only => [:new]
  before_filter :destroy_not_logged_search_sessions, :only => [:index]


  def index
    render :layout=>"new_employer_landing_page"
  end

  def new
    if session[:employer]
      @employer = Employer.where(:id=>session[:employer].id).first
      @corporte_account = CorporateAccount.new

      @f_name = @employer.first_name.empty? ? nil : @employer.first_name.force_encoding('utf-8')
      @l_name = @employer.last_name.empty? ? nil : @employer.last_name.force_encoding('utf-8')
      @email = @employer.email
      @disable_password_field = false
    else
      @employer = Employer.new
      @corporte_account = CorporateAccount.new
      @disable_password_field = false
    end


    if request.post? and !params[:firstName].blank? and !params[:lastName].blank? and !params[:Email].blank?
      @f_name = @employer.first_name = params[:firstName].force_encoding('utf-8')
      @l_name = @employer.last_name = params[:lastName].force_encoding('utf-8')
      @email = @employer.email = params[:Email].force_encoding('utf-8')
    end
  end

  def create
    @corporte_account = CorporateAccount.new
    @error_json = ""
    if session[:employer]
      clear_password_key_from_params
    end
    if session[:employer]
      @employer = Employer.where(:id => session[:employer].id).first
      @employer.attributes = params[:employer]
    else
      @employer = Employer.new(params[:employer])
    end
    @f_name = @employer.first_name.nil? ? nil : @employer.first_name
    @l_name = @employer.last_name.nil? ? nil : @employer.last_name
    @email = @employer.email

    if(params[:save_type] == "save_return") #&& !params["employer"]["email"].empty? && !params["employer"]["password"].empty? && !params["employer"]["password_confirmation"].empty?)
      if(validate_before_save_return() == 0)
        render :action => :new
        return
      end
      emp = Employer.where("LOWER(email) like ? and deleted = 0",params["employer"]["email"].downcase).first
      job_seeker = JobSeeker.where("LOWER(email) like ?",params["employer"]["email"].downcase).first

      if !emp.nil? #old user
        if !session[:employer].nil?
          if session[:employer].email != emp.email
            @email_valid = true
            @error_arr = [["email", "Email is already taken"]]
            #if email id is already taken
            @error_json = json_from_error_arr(@error_arr )
            render :action=>"new"
            return
          end
        else
          @email_valid = true
          @error_arr = [["email", "Email is already taken"]]
          #if email id is already taken
          @error_json = json_from_error_arr(@error_arr )
          render :action=>"new"
          return
        end
      end

      if !job_seeker.nil?
        if !session[:employer].nil?
          if session[:employer].email != job_seeker.email
            @email_valid = true
            @error_arr = [["email", "Email is already taken"]]
            #if email id is already taken
            @error_json = json_from_error_arr(@error_arr )
            render :action=>"new"
            return
          end
        else
          @email_valid = true
          @error_arr = [["email", "Email is already taken"]]
          #if email id is already taken
          @error_json = json_from_error_arr(@error_arr )
          render :action=>"new"
          return
        end
      end

      @employer.completed_registration_step = 0
      @employer.save(:validate => false)
      redirect_to :controller => :login, :action => :logout
      return
    else
      #@employer.activated = true
    end
    @account_type = AccountType.find_by_id(3)
    @employer.account_type_id = @account_type.id
    @employer.completed_registration_step = EMPLOYER_ACCOUNT_SETUP_STEP

    emp = Employer.where("LOWER(email) like ? and deleted = 0",@employer.email.downcase).first
    job_seeker = JobSeeker.where("LOWER(email) like ?",@employer.email.downcase).first

    if not session[:employer].nil?
      if emp.nil?
        emp_set = true
      else
        if session[:employer].email == emp.email and not params[:employer].nil?
          emp_set = true
        else
          emp_set = false
        end
      end
    else
      if emp.nil?
        emp_set = true
      else
        emp_set = false
      end
    end
    if emp_set and job_seeker.nil?
      if @employer.save(:validate=>false)
        reload_employer_session(@employer)
        if !params[:save_type].blank? && params[:save_type] == "payment"
          redirect_to :controller=>:employer_payment,:action=>:index
          return
        else
          redirect_to :controller=>:home,:action=>:index
          return
        end
      end
    else
      if params[:employer].nil?
        @email_valid = false
      else
        @email_valid = true
      end
      render :action=>"new"
      return
    end
  end


  def create_corporate_account
    @corporate_account = CorporateAccount.new(params[:corporate_account])

    respond_to do |format|
      if @corporate_account.save
        Notifier.corporate_account_request(@corporate_account.email, request.env["HTTP_HOST"]).deliver
        Notifier.new_corporate_account_request(request.env["HTTP_HOST"]).deliver
        session[:corporate_account] = true
        format.html {redirect_to(:controller => 'home', :action => 'index')}
      end
    end
  end

  def update_account
    @employer = Employer.where("id = ?", session[:employer].id).first
    @job_seeker_email = JobSeeker.where(:email => params[:email]).first
    @employer_email = Employer.where(:email => params[:email],:deleted=>false).where("id != #{session[:employer].id}").first
    if(@job_seeker_email.nil? and @employer_email.nil?)
      @employer.first_name = params[:first_name]
      @employer.last_name = params[:last_name]
      @employer.email = params[:email]
      @employer.save(:validate=>false)
      if params[:edit_password] == "1"
        old_pwd = Employer.encrypted_password(params[:old_password])
        if old_pwd != @employer.hashed_password
          render 'old_pass_mismatch', :formats => [:js], :layout => false
        else
          @employer.password = params[:new_password]
          @employer.save(:validate => false)
          @password_update = true
          reload_employer_session
          render 'update_employer', :formats=>[:js], :layout=>false
        end
      else
        reload_employer_session
        render 'update_employer', :formats=>[:js], :layout=>false
      end
    else
      render 'duplicate_email_address', :formats => [:js], :layout => false
    end
    return
  end

  def update_company
    @employer = Employer.where("id = ?", session[:employer].id).first
    @company = @employer.company

    @company_info = @company
    @company.name = params[:company_name]
    @company.street_one = params[:address_two]
    @company.city = params[:city]
    @company.country = params[:country]
    if params[:zip_code]=="Zip Code (optional)"
      @company.zip = nil
    else
      @company.zip = params[:zip_code]
    end
    @company.state = params[:state]
    @company.phone = params[:area_code].empty? ? "#{params[:telephone]}" : "#{params[:area_code]}-#{params[:telephone]}"
    @company.website = params[:website]

    if @company.save(:validate => false)
      reload_employer_session(@employer)
      broadcast_job_feed
      render 'update_employer_company', :formats=>[:js], :layout=>false
      return
    else
      @company.errors.each{|k,v|
        @error_arr  << [k,v]
      }
      @reset = true
      @error_json = json_from_error_arr(@error_arr)
      render 'update_employer_company_error', :formats=>[:js], :layout=>false
      return
    end
  end

  def validate_before_save_return
    email = params[:employer][:email].to_s
    pwd = params[:employer][:password].to_s
    cnf_pwd = params[:employer][:password_confirmation].to_s
    msg = []

    #validations for email
    if(email.empty? || email == 'Email')
      msg.push(["email","Email field can't be empty  "])
    elsif(email.match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).nil?)
      msg.push(["email","Email is invalid or Email is already taken  "])
    end

    #validations for password
    if(pwd.empty? || cnf_pwd.empty? || pwd == 'Create Password' || cnf_pwd == 'Confirm Password')
      msg.push(["password","Password fields can't be empty  "])
    elsif(pwd != cnf_pwd)
      msg.push(["password","Passwords do not match. Please try again."]) #if(pwd != cnf_pwd)
    end

    if(email.empty? || email.match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).nil? || pwd.empty? || cnf_pwd.empty? || pwd != cnf_pwd)
      @error_json = json_from_error_arr(msg)
      return 0
    end
    return 1
  end

  def spending_limit
    @total_user_amt = 0.0
    emp = Employer.find_by_id(params[:spending_user_id])
    amt = params[:limit_text].delete"$"
    if emp.spending_flag == false
      emp.equal_assign_spending_limits(params[:spending_user_id], amt, session[:employer].id)
    else
      emp.calculus_assign_spending_limits(params[:spending_user_id], amt, session[:employer].id)
    end
    if not session[:employer].is_root?
      reload_employer_session
      employer_obj = session[:employer]
      employer_obj.subtree_ids.each do |child_sub|
        emp_obj = Employer.find_by_id(child_sub)
        if employer_obj.spending_flag
        @self_amt = employer_obj.spending_limits.last.spend_limit
        @payments = employer_obj.spending_limits.last.spend_limit - employer_obj.spending_limits.last.available_balance
        @total_user_amt = @total_user_amt + emp_obj.spending_limits.last.spend_limit if not emp_obj.spending_limits.last.nil?
        @allocated_amt = @total_user_amt - @self_amt
        end
      end
    end
  end

  def set_monthly_auto_renew
    emp = Employer.find_by_id(params[:emp_id])
    emp.monthly_auto_renew(emp.id, params[:set])
    render :text => "Done", :layout => false
  end

  def set_spending_limit_no
    emp = Employer.find_by_id(params[:emp_id])
    emp.spending_limit_no(emp.id)
    render :text => "Done", :layout => false
  end


  private

  def validate_current_step
    if !session[:employer].blank? and (session[:employer].completed_registration_step != 0)
      redirect_to redirect_to_employer_registration_step
    elsif !session[:job_seeker].blank? and (!session[:job_seeker].completed_registration_step.blank? or session[:job_seeker].completed_registration_step == 0)
      redirect_to redirect_to_registration_step()
    end
  end

  def clear_password_key_from_params
    if not params[:employer].nil?
    if params[:employer][:password].blank?
      params[:employer].delete(:password)
      params[:employer].delete(:password_confirmation)
    end
    end
  end


end