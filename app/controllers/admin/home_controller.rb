# coding: UTF-8
class Admin::HomeController < ApplicationController
  require 'csv'
  before_filter :admin_login_required
  layout "admin"
  
  def index
    restrict_admin_from_accessing_not_authorized_pages("Employer Privileges")
    @companies = Employer.privileged_list
  end

  def referral_fee
    restrict_admin_from_accessing_not_authorized_pages("Referral Fee")
    @emp_with_company = Employer.email_with_company
  end

  def account
    @administrator = Administrator.new
  end

  def create_admin
    @administrator = Administrator.new(params[:administrator])
    generate_password = Employer.generate_random_password
    @administrator.password = generate_password
    @administrator.active = 1
    if @administrator.save
      params[:access_levels].each do |define_access_level|
        access_level = AccessLevel.find_by_id(define_access_level.to_i)
        if access_level
          AdminAccessLevel.create!(:administrator_id => @administrator.id, :access_level_id => access_level.id)
        end
      end
      Notifier.welcome_new_administrator(@administrator.email, generate_password, request.env["HTTP_HOST"]).deliver
      render 'create_admin_success', :formats=>[:js], :layout=>false
    else
      render 'create_admin_error', :formats=>[:js], :layout=>false
    end
  end

  def delete_job_seeker
    js = JobSeeker.find_by_id(params[:id].to_i)
    unless js.nil?
      if js.request_deleted
        js.request_deleted = false
        js.deleted = true
        js.save(:validate => false)
        js.delay(:priority=>1).self_delete
        @cs_delete_rec = JobSeeker.where(:request_deleted => true).order('updated_at DESC')
        render 'admin_job_seeker_delete_cancel', :formats=>[:js], :layout=>false
      else
        #popup
        render 'show_popup_delete', :formats=>[:js], :layout=>false
      end
    else
      render 'show_popup_delete', :formats=>[:js], :layout=>false
    end
  end

  def delete_employer
    emp = Employer.find_by_id(params[:id].to_i)
    unless emp.nil?
      if emp.request_deleted
        if emp.is_root?
          emp.subtree_ids.each do |emp_id|
            emp_child = Employer.find_by_id(emp_id)
            if !emp.nominated_employer_id.nil?
              emp_child.deleted = true if emp_child.is_root?
              emp_child.request_deleted = false if emp_child.is_root?
            else
              emp_child.deleted = true
              emp_child.request_deleted = false
            end
            emp_child.save(:validate => false)
          end
        else
          emp.deleted = true
          emp.request_deleted = false
          emp.save(:validate => false)
        end
        emp.delay(:priority=>1).self_delete
        @emp_delete_rec = Employer.where(:request_deleted => true).order('updated_at DESC')
        render 'admin_employer_delete_cancel', :formats=>[:js], :layout=>false
      else
        #popup
        render 'show_popup_delete', :formats=>[:js], :layout=>false
      end
    else
      render 'show_popup_delete', :formats=>[:js], :layout=>false
    end
  end

  def corporate_account
    restrict_admin_from_accessing_not_authorized_pages("Corporate Accounts")
    @corporate_accounts = CorporateAccount.where(:is_approved => false)
  end

  def change_password
    administrator = Administrator.find_by_email(session[:administrator].email)
    if !administrator.nil? and administrator.authenticate(params[:old_password]) and administrator.active == true
      administrator.update_attribute(:password,params[:new_password])
      render 'change_password', :formats=>[:js], :layout=>false
    else
      render 'invalid_password', :formats=>[:js], :layout=>false
    end
  end
  
  def admin_login_required
    if session[:administrator].nil?
      redirect_to :controller=>:login
    end
  end

  def referral_fee_data
    @referral_from = params[:from]
    @referral_to = params[:to]
    @company_id = params[:employer_company_select]
    @company_status = EmployerPrivilege.select("status").where(:company_id=>@company_id).last
    @referral_fee_data = ReferralFee.referral_fee_data(DateTime.parse(@referral_from).getutc.strftime("%Y-%m-%d %H:%M:%S"), DateTime.parse(@referral_to).getutc.strftime("%Y-%m-%d %H:%M:%S"), @company_id)
    @referral_from = @referral_from.to_date.to_formatted_s(:long_ordinal)
    @referral_to = @referral_to.to_date.to_formatted_s(:long_ordinal)
    render 'referral_fee_data', :formats => [:js], :layout => false
  end

  def add_to_privileged_list
    @company_id = params[:company_id]
    @credit_value = params[:credit_value]
    @discout_value = params[:fee_discount]
    EmployerPrivilege.create(:company_id=>@company_id,:credit_value=>@credit_value,:discount_value=>@discout_value,:status=>true)
    render 'add_to_privileged_list', :formats=>[:js], :layout=>false
  end

  def remove_from_privileged_list
    @company_id = params[:company_id]
    company = EmployerPrivilege.where(:company_id=>@company_id).last
    if not company.nil?
      company.status = false
      company.save
    end
    render 'remove_from_privileged_list', :formats=>[:js], :layout=>false
  end

  def grant_email_domain_authentication
    @company_id = params[:company_id].to_i
    company = Company.find(@company_id)
    unless company.nil?
      company.hilo_subscription = true
      if company.save(:validate=>false)
        render 'grant_email_domain_authentication', :formats=>[:js], :layout=>false
        return
      end
    end
    render :text => "error"
  end

  def revoke_email_domain_authentication
    @company_id = params[:company_id].to_i
    company = Company.find(@company_id)
    unless company.nil?
      company.hilo_subscription = false
      CompanyDomain.delete_all(:company_id => company.id)
      if company.save(:validate=>false)
        render 'revoke_email_domain_authentication', :formats=>[:js], :layout=>false
        return
      end
    end
    render :text => "error"
  end

  def mark_as_paid
    @id = params[:id]
    row = ReferralFee.where(:id=>@id).first
    row.update_attribute(:referral_fee_flag,true)
    render 'mark_as_paid', :formats=>[:js], :layout=>false
  end

  def privileged_list_history
    @company_id = params[:company_id]
    @history = EmployerPrivilege.where(:company_id=>@company_id).order("created_at DESC")
    @employer = Employer.where(:company_id=>@company_id).first
    render 'privileged_list_history', :formats=>[:js], :layout=>false
  end

  def new_admin_email_presence
    admin = Administrator.where("LOWER(email) like ?",params[:email_check].downcase).first

    if !admin.nil?
      render :text => "Email is already taken"
    else
      render :text => "Email available"
    end
  end

  def search_company
    @company = Company.find_by_name(params[:company_name])
    
    if @company
      render :text => "exists"
    else
      render :text => "not_exists"
    end
  end

  def validate_email
    emp = Employer.where("LOWER(email) like ?",params[:email_check].downcase).first
    job_seeker = JobSeeker.where("LOWER(email) like ?",params[:email_check].downcase).first

    if emp.nil? && job_seeker.nil?
      render :text => "Email_available"
    else
      render :text => "Email is already taken"
    end
  end

  def create_new_employer_account
    success = ''
    @company = Company.new(params[:company])

    if @company.save
      @employer = Employer.new(params[:employer])
      @employer.company_id = @company.id
      @generate_password = Employer.generate_random_password
      @employer.password = @generate_password
      @employer.contact_email = params[:employer][:email]
      @employer.preferred_contact = "contact_email"
      @employer.completed_registration_step = 1
      @employer.account_type_id = 1
      @employer.activated = 1
      @employer.save
      success = true
    else
      success = false
    end

    respond_to do |format|
      if success == true
        Notifier.welcome_employer(@employer.email, @generate_password, request.env["HTTP_HOST"]).deliver
        format.js
      end
    end
  end

  def delete_corp_account
    @corporate_account = CorporateAccount.find_by_id(params[:id].to_i)
    if @corporate_account.update_attributes(:is_approved => true)
      render :text => "success"
    else
      render :text => "error"
    end
  end

  def authorize_admin_access
    authorize_access_levels = session[:administrator].access_levels
    if authorize_access_levels[0].name != "All"
      if authorize_access_levels[0].name == "Employer Privileges"
        redirect_to admin_home_index_path
      elsif authorize_access_levels[0].name == "Referral Fee"
        redirect_to referral_fee_admin_home_index_path
      elsif authorize_access_levels[0].name == "Corporate Accounts"
        redirect_to corporate_account_admin_home_index_path
      elsif authorize_access_levels[0].name == "Account Delete Request"
        redirect_to employer_delete_request_admin_home_index_path
      elsif authorize_access_levels[0].name == "Right Management"
        redirect_to make_right_company_admin_home_index_path
      else
        redirect_to account_admin_home_index_path
      end
    else
      redirect_to admin_home_index_path
    end
  end

  def restrict_admin_from_accessing_not_authorized_pages(access_level)
    if session[:administrator].access_levels.select{|v| v.name == access_level or v.name == "All"}.blank?
      if access_level == "Employer Privileges"
        authorize_admin_access
      else
        redirect_to account_admin_home_index_path
      end
    end
  end

  def generate_promo_codes
    number_of_promo_codes = params[:promo_code].to_i
    promo_codes = Array.new
    for i in 1..number_of_promo_codes
      promotional_code = PromotionalCode.create_random_code_admin_site_activation(19.99, "site_activation_credit", "")
      promo_codes << promotional_code
    end

    csv_report = CSV.generate do |csv|
      cols = ["ID", "Promotional Code", "Table"]
      csv << cols

      promo_codes.each do |promo_code|
        csv << [promo_code.id, promo_code.code, "promotional_codes"]
      end
    end

    # Fix for IE-8
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    # Fix for IE-8 ends here
    send_data(csv_report, :type => 'text/csv; charset=utf-8; header=present', :filename => "Promotional Code.csv")
  end

  def employer_delete_request
    restrict_admin_from_accessing_not_authorized_pages("Account Delete Request")
    @emp_delete_rec = Employer.where(:request_deleted => true).order('updated_at DESC')
  end

  # Career Seeker Deletion Request Page (Default Page)
  def career_seeker
    restrict_admin_from_accessing_not_authorized_pages("Account Delete Request")
    @cs_delete_rec = JobSeeker.where(:request_deleted => true).order('updated_at DESC')
  end

  def admin_employer_delete_cancel
    emp = Employer.find_by_id(params[:id].to_i)
    unless emp.nil?
      if emp.request_deleted
        if ((emp.is_root? and not emp.nominated_employer_id.nil?) or (not emp.is_root?))
          emp.request_deleted = false
          emp.nominated_employer_id = nil
          emp.save(:validate => false)
        else
          emp.subtree_ids.each do |emp_id|
            emp_child = Employer.find_by_id(emp_id)
            if not emp_child.deleted
              emp_child.request_deleted = false
              emp_child.nominated_employer_id = nil
            else
              emp_child.deleted = false
            end
            emp_child.save(:validate => false)
          end
        end
        Notifier.admin_delete_cancel(emp, request.env["HTTP_HOST"]).deliver
        @emp_delete_rec = Employer.where(:request_deleted => true).order('updated_at DESC')
      else
        render 'show_popup_delete', :formats=>[:js], :layout=>false
      end
    else
      render 'show_popup_delete', :formats=>[:js], :layout=>false
    end
  end

  def refresh_table
    @emp_delete_rec = Employer.where(:request_deleted => true).order('updated_at DESC')
    render 'admin_employer_delete_cancel', :formats=>[:js], :layout=>false
  end

  def admin_job_seeker_delete_cancel
    js = JobSeeker.find_by_id(params[:id].to_i)
    unless js.nil?
      if js.request_deleted
        js.request_deleted = false
        js.save(:validate => false)
        Notifier.admin_delete_cancel(js, request.env["HTTP_HOST"]).deliver
        @cs_delete_rec = JobSeeker.where(:request_deleted => true).order('updated_at DESC')
      else
        #popup
        render 'show_popup_delete', :formats=>[:js], :layout=>false
      end
    else
      render 'show_popup_delete', :formats=>[:js], :layout=>false
    end
  end

  def admin_employer_delete
    @emp = Employer.find_by_id(params[:id].to_i)
  end

  def admin_job_seeker_delete
    @js = JobSeeker.find_by_id(params[:id].to_i)
  end

  def right_management
    restrict_admin_from_accessing_not_authorized_pages("Right Management")
    @companies = Employer.right_list
  end

  def grant_right_authentication
    @company_id = params[:company_id].to_i
    company = Company.find(@company_id)
    unless company.nil?
      company.parent_id = RIGHT_COMPANY_ID
      if company.save(:validate=>false)
        company.jobs.each do |job|
          PairingLogic.delay.pairing_value_job(job, "from_rake_task")
        end
        render 'grant_right_authentication', :formats=>[:js], :layout=>false
        return
      end
    end
    render :text => "error"
  end

  def revoke_right_authentication
    @company_id = params[:company_id].to_i
    company = Company.find(@company_id)
    unless company.nil?
      company.parent_id = nil
      if company.save(:validate=>false)
        company.jobs.each do |job|
          PairingLogic.delay.pairing_value_job(job, "from_rake_task")
        end
        render 'revoke_right_authentication', :formats=>[:js], :layout=>false
        return
      end
    end
    render :text => "error"
  end
  
end