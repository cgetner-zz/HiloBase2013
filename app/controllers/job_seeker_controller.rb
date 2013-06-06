# coding: UTF-8

class JobSeekerController < ApplicationController
  include ActiveMerchant::Billing
  before_filter :validate_current_step
  after_filter :page_loaded_once,:only=>[:new]
  skip_before_filter :verify_authenticity_token, :only => [:new]
   
  def new
    if session[:bridge_response].nil?
      session[:track_shared_job_id] = nil
      session[:track_shared_platform_id] = nil
      session[:track_shared_company_id] = nil
      session[:job_not_active] = nil
      session[:company_not_active] = nil
    end
    if session[:job_seeker]
      @job_seeker = JobSeeker.where("id=?", session[:job_seeker].id).first
      @job_seeker.first_name = @job_seeker.first_name.force_encoding('utf-8')
      @job_seeker.last_name = @job_seeker.last_name.force_encoding('utf-8')
      @job_seeker.city = @job_seeker.city.force_encoding('utf-8') if not @job_seeker.city.nil?
    else
      @job_seeker = JobSeeker.new
    end
    session[:sharing_sign_up] = 1
    if request.post? and !params[:firstName].blank? and !params[:lastName].blank? and !params[:Email].blank? and !params[:birkmanId].blank?
         
      if validate_existing_email()
        @job_seeker.first_name = params[:firstName].force_encoding('utf-8')
        @job_seeker.last_name = params[:lastName].force_encoding('utf-8')
        @job_seeker.email = params[:Email].force_encoding('utf-8')
        @job_seeker.city = params[:city].force_encoding('utf-8')
        session[:pass_through] = params[:birkmanId].force_encoding('utf-8')
      else
        @job_seeker.first_name = params[:firstName].force_encoding('utf-8')
        @job_seeker.last_name = params[:lastName].force_encoding('utf-8')
        @job_seeker.city = params[:city].force_encoding('utf-8')
        session[:pass_through] = params[:birkmanId].force_encoding('utf-8')
        @email = false
      end
         
    else
      session[:pass_through] = nil
    end
      
    render :layout => 'registration'
  end
  
  def create
    @error_json = ""
    if params[:job_seeker].nil?
      redirect_to :action => :new
      return false
    end
    if session[:job_seeker]
      clear_password_key_from_params()
    end
        
    if session[:job_seeker]
      @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
      @job_seeker.attributes = params[:job_seeker]
    else
      @job_seeker = JobSeeker.new(params[:job_seeker])
    end
    #@job_seeker.bridge_response = session[:bridge_response] if not session[:bridge_response].nil?
    #@job_seeker.track_shared_job_id = session[:track_shared_job_id] if not session[:track_shared_job_id].nil?
    #@job_seeker.track_shared_company_id = session[:track_shared_company_id] if not session[:track_shared_company_id].nil?
    #@job_seeker.track_platform_id = session[:track_shared_platform_id] if not session[:track_shared_platform_id].nil?
    @job_seeker.track_shared_job_id = nil if @job_seeker.track_shared_job_id.blank?
    @job_seeker.track_shared_company_id = nil if @job_seeker.track_shared_company_id.blank?
    
    if !@job_seeker.internal_candidate.blank?
      unless @job_seeker.track_shared_company_id.blank?
        if Company.find(@job_seeker.track_shared_company_id.to_i).verify_random_token(@job_seeker.random_token)
          company = Company.find(@job_seeker.track_shared_company_id.to_i)
          employer_privilege = company.employer_privileges.last
          unless employer_privilege.nil?
            if employer_privilege.status == true
              @job_seeker.ics_type_id = 2
            else
              @job_seeker.ics_type_id = 1
            end
            @job_seeker.company_id = company.id
          else
            @job_seeker.ics_type_id = 1
            @job_seeker.company_id = company.id
          end
        else
          @job_seeker.bridge_response = nil
          @job_seeker.track_shared_job_id = nil
          @job_seeker.track_shared_company_id = nil
          @job_seeker.track_platform_id = nil
        end
        #session[:random_token] = nil
      end
      #session[:internal_candidate] = nil
    end

    #check for hilo subscription
    #will cause problem when two companies have specified the same email domain
    cdom = CompanyDomain.all.detect { |cd| @job_seeker.email.split('@')[1] == cd.domain }
    #company = Company.find(cdom.company_id)
    unless cdom.nil?
      @job_seeker.company_id = cdom.company_id
      @job_seeker.ics_type_id = 3
    end
    #

    if !params[:save_type].blank? && params[:save_type] == "saveandreturn"
      emp = Employer.where(:email => params[:job_seeker][:email].downcase, :deleted => false).first
      job_seeker = JobSeeker.where(:email => params[:job_seeker][:email].downcase, :deleted => false).first

      if !(job_seeker.nil?)
        if !session[:job_seeker].nil?
          if (job_seeker.email != session[:job_seeker].email)
            @email = false;
            render :action=>"new", :layout => 'registration'
            return
          end
        else
          @email = false;
          render :action=>"new", :layout => 'registration'
          return
        end
      end

      if !(emp.nil?)
        if !session[:job_seeker].nil?
          if (emp.email != session[:job_seeker].email)
            @email = false;
            render :action=>"new", :layout => 'registration'
            return
          end
        else
          @email = false;
          render :action=>"new", :layout => 'registration'
          return
        end
      end
           
      if @job_seeker.save(:validate => false)
        session[:bridge_response] = nil
        session[:track_shared_job_id] = nil
        session[:track_shared_company_id] = nil
        session[:job_not_active] = nil
        session[:company_not_active] = nil
        session[:track_shared_platform_id] = nil
        reload_seeker_session(@job_seeker)
        redirect_to :controller=>:login, :action=>:logout
        return
      else
        @job_seeker.errors.each{|k,v|
          @error_arr  << [k,v]
        }
        @error_json = json_from_error_arr(@error_arr )
        @email = false;
        render :action=>"new", :layout => 'registration'
        return
      end
    end
            
    if !params[:save_type].blank? && params[:save_type] == "questionnaire"
      @job_seeker.completed_registration_step = ACCOUNT_SETUP_STEP
    end
    @job_seeker.contact_email = @job_seeker.email
    @job_seeker.preferred_contact = "contact_email"
    @job_seeker.city = params[:job_seeker][:city]
    if @job_seeker.save
      session[:bridge_response] = nil
      session[:track_shared_job_id] = nil
      session[:track_shared_company_id] = nil
      session[:company_not_active] = nil
      session[:job_not_active] = nil
      session[:company_not_exist] = nil
      session[:sharing_company] = nil
      session[:sharing_platform_id] = nil
      
      reload_seeker_session(@job_seeker)

      if @job_seeker.bridge_response == "yes" or @job_seeker.bridge_response == "no"
        job_seeker_privilege = @job_seeker.job_seeker_created_privilege
        if not job_seeker_privilege.nil? #2,3,4
          credit = job_seeker_privilege.credit_value
          company_name = job_seeker_privilege.comp_name
          discount = job_seeker_privilege.discount_value
          ics_type = @job_seeker.ics_type_id
        else #1,4
          credit = nil
          company_name = nil
          discount = nil
          ics_type = @job_seeker.ics_type_id
        end
      else #3,4
        credit = nil
        if @job_seeker.ics_type_id == 3
          company_name = Company.find(@job_seeker.company_id).name
          
        else
          company_name = nil
        end
        discount = nil
        ics_type = @job_seeker.ics_type_id
      end

      Notifier.account_create(@job_seeker.email, @job_seeker.first_name, credit, discount, company_name, request.env["HTTP_HOST"], ics_type).deliver

      if !params[:save_type].blank? && params[:save_type] == "questionnaire"
        if @job_seeker.ics_type_id != 3
          redirect_to :controller=>:questionnaire
          return
        else
          @job_seeker.update_column(:email_verified, 0)
          clear_session_on_logout
          session[:ics_type_three] = "yes"
          redirect_to :controller=>:home,:action=>:index
          return
        end
      else
        redirect_to :controller=>:login, :action=>:logout
        return
      end
    else
      @job_seeker.errors.each{|k,v|
        @error_arr  << [k,v]
      }
      @error_json = json_from_error_arr(@error_arr )
      @email = false;
      render :action=>"new", :layout => 'registration'
      return
    end
     
  end
 
  private 
  
  def clear_password_key_from_params
    if params[:job_seeker][:password].blank?
      params[:job_seeker].delete(:password)
      params[:job_seeker].delete(:password_confirmation)
    end
  end
  
  def validate_current_step
    if !session[:job_seeker].blank? and (!session[:job_seeker].completed_registration_step.blank? or session[:job_seeker].completed_registration_step == 0)
      redirect_to redirect_to_registration_step()
    elsif !session[:employer].blank? and (session[:employer].completed_registration_step != 0)
      redirect_to redirect_to_employer_registration_step()
    end
  end
  
  def validate_existing_email
    jobseeker = JobSeeker.find(:first, :conditions => ["email = ?", params[:Email]])
    employer = Employer.find(:first, :conditions => ["email = ?", params[:Email]])
    if jobseeker.nil? and employer.nil?
      return true
    else
      return false
    end
  end
  
  def determine_layout
    return "registration"
  end
    
end
