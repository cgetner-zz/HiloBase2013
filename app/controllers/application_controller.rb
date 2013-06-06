# coding: UTF-8
class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  helper_method :current_user
  protect_from_forgery
  
  before_filter :ssl_required  
  before_filter :filter_for_all
  before_filter :set_cache_buster
  before_filter :set_locale

  def set_locale
    if $ENABLE_LANGUAGE_LOCALIZATION == 0
      I18n.locale = "en"
    else
      available = %w{en fr-CA}
      if session[:locale].nil?
        I18n.locale = http_accept_language.preferred_language_from(available)
      else
        I18n.locale = session[:locale]
      end
    end
  end

  def xref_login_required
    if session[:employer].nil?
      session[:from_email_employer_alert] = params[:cs_id].to_s+"_"+params[:position_id].to_s
      redirect_to :controller=>"employer", :action=>"index"
    end
  end


  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
  def ssl_required
    return if self.controller_name == 'job_feed'
    urls = request.env["HTTP_HOST"].split(".")
    if Rails.env == "production" or Rails.env == "staging"
      if urls[0] == "www"
        redirect_to "https://#{urls[1]}.#{urls[2]}#{request.env["REQUEST_URI"]}"
      elsif !request.ssl?
        redirect_to "https://#{request.env["HTTP_HOST"]}#{request.env["REQUEST_URI"]}"
      end
    end
  end

  def broadcast_job_feed
    if session[:employer]
      BroadcastController.new.delay(:priority => 6).send_feed(session[:employer].company_id)
    end
  end

  def login_required
    if current_user.nil?
      flash[:notice] = "You must login to access this page"
      session[:return_to] = request.request_uri
      redirect_to new_session_path and return
    end
  end
  
  def remaining_credit_amount
  end

  def clear_xref_session
    session[:selected] = nil
  end

  def destroy_not_logged_search_sessions
    session[:map_score_x] = session[:map_score_y] = session[:emp_workenv_text] = session[:emp_workenv_color] = session[:js_workenv_text] = session[:gues_js_id] = nil
  end

  protected

  def check_employer_job_save_permission
    if params[:jobid].present? and params[:jobid]!="0"
      @job = Job.find_by_id(params[:jobid].to_i)
    elsif params[:job_id].present? and params[:job_id]!="0"
      @job = Job.find_by_id(params[:job_id].to_i)
    elsif params[:id].present? and params[:id]!="0"
      @job = Job.find_by_id(params[:id].to_i)
    elsif params[:jid].present? and params[:jid]!="0"
      @job = Job.find_by_id(params[:jid].to_i)
    end
    unless @job.nil?
      if @job.deleted
        session[:job_deleted_warning] = true
        if request.xhr?
          render '/ajax/job_deleted', :format => [:js], :layout => false
        else
          redirect_to :controller=>:employer_account
        end
        return false
      elsif not session[:employer].subtree_ids.include?(@job.employer_id)
        session[:job_access_denied_warning] = true
        if request.xhr?
          render '/ajax/check_employer_job_save_permission', :format => [:js], :layout => false
        else
          redirect_to :controller=>:employer_account
        end
        return false
      end
    end
  end

  def check_category_status
    if params[:cat_id].present? or params[:company_group_id].present?
      category_id = params[:cat_id].present? ? params[:cat_id].to_i : params[:company_group_id].present? ? params[:company_group_id].to_i : nil
      unless category_id.nil?
        cat = CompanyGroup.find_by_id(category_id)
        unless cat.nil?
          if params[:cat_id].present?
            if cat.deleted == true or session[:employer].id != cat.employer_id
              session[:category_deleted_warning] = true
              if request.xhr?
                render '/ajax/check_employer_job_save_permission', :format => [:js], :layout => false
              else
                redirect_to :controller=>:employer_account
              end
            end
          elsif params[:company_group_id].present?
            if cat.deleted == true or not session[:employer].subtree_ids.include?(cat.employer_id)
              session[:category_deleted_warning] = true
              if request.xhr?
                render '/ajax/check_employer_job_save_permission', :format => [:js], :layout => false
              else
                redirect_to :controller=>:employer_account
              end
            end
          end
        else
          redirect_to :controller=>:employer_account
        end
      end
    end
  end

  def check_availability
    if params[:cat_id].present?
      if CompanyGroup.find(params[:cat_id].to_i).deleted == true or not session[:employer].subtree_ids.include?(CompanyGroup.find(params[:cat_id].to_i).employer_id)
        render '/ajax/category_reassign_deleted', :format => [:js], :layout => false
      end
    elsif params[:new_cat_id].present?
      if Job.find(params[:job_id].to_i).deleted == true or not session[:employer].subtree_ids.include?(Job.find(params[:job_id].to_i).employer_id)
        render '/ajax/job_reassign_deleted', :format => [:js], :layout => false
      elsif CompanyGroup.find(params[:new_cat_id].to_i).deleted == true or not session[:employer].subtree_ids.include?(CompanyGroup.find(params[:new_cat_id].to_i).employer_id)
        render '/ajax/category_reassign_deleted', :format => [:js], :layout => false
      end
    end
  end

  def check_for_suspended_users
    unless session[:employer].blank?
      reload_employer_session
      if session[:employer].suspended == true || session[:employer].tree_suspended == true
        session[:user_suspended] = true
        if request.xhr?
          render '/ajax/logout_user', :format => [:js], :layout => false
        else
          redirect_to :controller=>:login, :action=>:logout
        end
      end
    end
  end

  def check_for_deleted_users
    unless session[:employer].blank?
      reload_employer_session
      if session[:employer].deleted == true
        session[:user_deleted] = true
        if request.xhr?
          render '/ajax/logout_user', :format => [:js], :layout => false
        else
          redirect_to :controller=>:login, :action=>:logout
        end
      end
    end
  end

  def check_job_seeker_deleted_viewed_profile
    if params[:seeker_id].present?
      job_seeker = JobSeeker.where(:id=>params[:seeker_id]).first
    elsif not session[:seeker_id_one_click].nil?
      job_seeker = JobSeeker.where(:id=>session[:seeker_id_one_click]).first
    end
    if job_seeker.nil?
      if request.xhr?
        render '/ajax/job_seeker_delete_popup', :format => [:js], :layout => false
      end
    end
  end
  
  def filter_for_all
    @error_arr= []
  end

  def page_loaded_once
    session[:page_loaded] = true
  end
  
  def set_reports_date_value
    from_arr = params[:from_date].split("-")
    @from_date = Time.local(from_arr[0],from_arr[1],from_arr[2], 0, 0,0).utc
    to_arr = params[:to_date].split("-")
    @to_date = Time.local(to_arr[0],to_arr[1],to_arr[2], 0, 0,0).utc
      
    if @from_date > @to_date
      @from_date = @from_date - 1
      params[:from_date] = @from_date.strftime("%Y-%m-%d")
    end
  end   
  
  def cs_form_address_str(job_location)
    str = "", full_addr = ""
    if not job_location.new_record?
      str = job_location.street_one if not job_location.street_one.blank?
      if not job_location.city.blank?
        str = str + ","
        str = str + job_location.city
      end
      if not job_location.state.blank?
        str = str + ","
        str = str + job_location.state
      end
      if not job_location.country.blank?
        str = str + ","
        str = str + job_location.country
      end
      if not job_location.zip_code.blank?
        str = str + ","
        str = str + job_location.zip_code
      end
      full_addr = str
    end
    return str, full_addr
  end
  
  def detailed_location(zip)    
    obj = Zipcode.where("zip = ?", zip).first
    if !obj.nil?
      return obj.city + ", " + obj.state
    else
      return " "
    end
  end
  
  def form_address_str(job_location)
    str = ""
    if not job_location.new_record?
      add_arr = []
      add_arr << job_location.street_one if not job_location.street_one.blank?
      add_arr << job_location.street_two if not job_location.street_two.blank?
      add_arr << job_location.city if not job_location.city.blank?
      add_arr << job_location.zip_code if not job_location.zip_code.blank?
      str = add_arr.join(",")
    end
    return str
  end
  
  def validate_job_for_employer
    reload_employer_session
    if params[:id] or params[:search_job_id]
      if params[:id]
        job_id = params[:id]
      elsif params[:search_job_id]
        job_id = params[:search_job_id]
      end

      if session[:employer].account_type_id != 3
        @job = Job.where("jobs.id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and jobs.deleted = ?", job_id, false).first
      else
        @job = Job.where("jobs.id = ? and jobs.employer_id IN (#{session[:employer].id}) and jobs.deleted = ?", job_id, false).first
      end
      if @job.blank?
        redirect_to :controller =>:employer_account, :action =>:index
        return
      end
    end
  end
        
  def get_candidate_pool_chart
    reload_employer_session
    if !@job.nil?
      if session[:employer].account_type_id != 3
        condition = session[:employer].root.subtree_ids.join(',')
      else
        condition = session[:employer].id
      end
      if @job.internal == true
        js = JobSeeker.where("company_id IN (#{@job.company.path_ids.join(',')}) AND ics_type_id IN (1,2,3)").collect{|c| c.id}
        if js.empty?
          js<<0
        end
      else
        js = JobSeeker.where("company_id = #{@job.company_id} OR company_id IS NULL").collect{|c| c.id}
      end
      @jobs_preview_count = Job.where("job_statuses.job_seeker_id IN (#{js.join(",")}) AND employers.id IN (#{condition}) AND job_statuses.read = ? AND jobs.id = ?  and jobs.deleted = 0", true, @job.id).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
      @jobs_wildcard_count = Job.where("job_statuses.job_seeker_id IN (#{js.join(",")}) AND employers.id IN (#{condition}) AND job_statuses.wild_card = ? AND jobs.id = ?  and jobs.deleted = 0", true, @job.id).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
      @jobs_interested_count = Job.where("job_statuses.job_seeker_id IN (#{js.join(",")}) AND employers.id IN (#{condition}) AND job_statuses.interested = ? AND jobs.id = ?  and jobs.deleted = 0", true, @job.id).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
      @jobs_considered_count = Job.where("job_statuses.job_seeker_id IN (#{js.join(",")}) AND employers.id IN (#{condition}) AND job_statuses.considering = ? AND jobs.id = ? and jobs.deleted = 0", true, @job.id).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
      @jobs_purchased_profiles_count = PurchasedProfile.select("purchased_profiles.id, DATE_FORMAT(created_at,'%M-%D-%Y') as date_val").where("job_seeker_id IN (#{js.join(",")}) AND employer_id IN (#{condition}) and created_at > ? and job_id =? and payment_id != 0", @job.created_at, @job.id).group("job_seeker_id ,job_id").length
    end
  end

  def get_xref_pool_chart(selected = -1)
    reload_employer_session
    if params[:cs_id]
      js = JobSeeker.find(params[:cs_id].downcase.gsub("cs","").to_i)
      if session[:selected].nil?
        selected = selected
      else
        selected = session[:selected]
      end
      case selected.to_i
      when -1
        if session[:employer].account_type_id != 3
          condition = Employer.find(session[:employer].id).subtree_ids.join(",")
        else
          condition = session[:employer].id
        end
      when 0
        condition = session[:employer].id
      else
        condition = Employer.find(selected).subtree_ids.join(",")
      end
      if  session[:employer].company.path_ids.include?(js.company_id) and [1,2,3].include? js.ics_type_id
        @xref_preview_count = Job.where("employers.id IN (#{condition}) AND job_statuses.read = ? AND job_statuses.job_seeker_id = ?  and jobs.deleted = 0", true, params[:cs_id].downcase.gsub("cs","").to_i).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
        @xref_wildcard_count = Job.where("employers.id IN (#{condition}) AND job_statuses.wild_card = ? AND job_statuses.job_seeker_id = ?  and jobs.deleted = 0", true, params[:cs_id].downcase.gsub("cs","").to_i).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
        @xref_interested_count = Job.where("employers.id IN (#{condition}) AND job_statuses.interested = ? AND job_statuses.job_seeker_id = ?  and jobs.deleted = 0", true, params[:cs_id].downcase.gsub("cs","").to_i).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
        @xref_considered_count = Job.where("employers.id IN (#{condition}) AND job_statuses.considering = ? AND job_statuses.job_seeker_id = ? and jobs.deleted = 0", true, params[:cs_id].downcase.gsub("cs","").to_i).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
      elsif js.ics_type_id == 4 and js.company_id.nil?
        @xref_preview_count = Job.where("employers.id IN (#{condition}) AND ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and job_statuses.read = ? AND job_statuses.job_seeker_id = ?  and jobs.deleted = 0", true, params[:cs_id].downcase.gsub("cs","").to_i).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
        @xref_wildcard_count = Job.where("employers.id IN (#{condition}) AND ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and job_statuses.wild_card = ? AND job_statuses.job_seeker_id = ?  and jobs.deleted = 0", true, params[:cs_id].downcase.gsub("cs","").to_i).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
        @xref_interested_count = Job.where("employers.id IN (#{condition}) AND ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and job_statuses.interested = ? AND job_statuses.job_seeker_id = ?  and jobs.deleted = 0", true, params[:cs_id].downcase.gsub("cs","").to_i).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
        @xref_considered_count = Job.where("employers.id IN (#{condition}) AND ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and job_statuses.considering = ? AND job_statuses.job_seeker_id = ? and jobs.deleted = 0", true, params[:cs_id].downcase.gsub("cs","").to_i).joins("join job_statuses on jobs.id = job_statuses.job_id join company_groups on jobs.company_group_id = company_groups.id join employers on employers.id = jobs.employer_id").length
      end
      
    end
  end
  
  def get_pos_profile_chart_data(selected = -1)
    reload_employer_session
    if params[:selected].present?
      if session[:employer].account_type_id != 3
        selected = params[:selected].to_i
      else
        selected = -1
      end
    end
    case selected.to_i
    when -1
      if session[:employer].account_type_id != 3
        condition = session[:employer].subtree_ids.join(",")
      else
        condition = session[:employer].id
      end
      created = session[:employer].created_at
    when 0
      condition = session[:employer].id
      created = session[:employer].created_at
    else
      begin
        condition = Employer.find(selected).subtree_ids.join(",")
        created = Employer.find(selected).created_at
      rescue
        condition = session[:employer].subtree_ids.join(",")
        created = session[:employer].created_at
      end
    end
    @jobs_preview_arr = Job.select("jobs.id, DATE_FORMAT(job_statuses.read_on,'%Y-%m-%d') as date_val").where("employers.id IN (#{condition}) AND job_statuses.read_on between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}' AND job_statuses.read = ?  and jobs.deleted = 0", true).joins("join job_statuses on jobs.id = job_statuses.job_id join employers on jobs.employer_id = employers.id")
    @jobs_new_preview = Job.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    jobs.id,
                    MONTH(jobs.created_at) created_at_month,
                    YEAR(jobs.created_at) created_at_year,
                    DATE(jobs.created_at) created_at,
                    jobs.created_at as date_create
                    from jobs
                    join job_statuses on jobs.id = job_statuses.job_id
                    join employers on jobs.employer_id = employers.id
              WHERE
                (employers.id IN (#{condition}) AND jobs.deleted = 0 AND job_statuses.read_on between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")

    @jobs_new_consider = Job.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    jobs.id,
                    MONTH(jobs.created_at) created_at_month,
                    YEAR(jobs.created_at) created_at_year,
                    DATE(jobs.created_at) created_at,
                    jobs.created_at as date_create
                    from jobs
                    join job_statuses on jobs.id = job_statuses.job_id
                    join employers on jobs.employer_id = employers.id
              WHERE
                (employers.id IN (#{condition}) AND jobs.deleted = 0 AND job_statuses.considered_on between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")

    @jobs_new_interest = Job.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    jobs.id,
                    MONTH(jobs.created_at) created_at_month,
                    YEAR(jobs.created_at) created_at_year,
                    DATE(jobs.created_at) created_at,
                    jobs.created_at as date_create
                    from jobs
                    join job_statuses on jobs.id = job_statuses.job_id
                    join employers on jobs.employer_id = employers.id
              WHERE
                (employers.id IN (#{condition}) AND jobs.deleted = 0 AND job_statuses.interested_on between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")
              
    
    @jobs_new_wild = Job.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    jobs.id,
                    MONTH(jobs.created_at) created_at_month,
                    YEAR(jobs.created_at) created_at_year,
                    DATE(jobs.created_at) created_at,
                    jobs.created_at as date_create
                    from jobs
                    join job_statuses on jobs.id = job_statuses.job_id
                    join employers on jobs.employer_id = employers.id
              WHERE
                (employers.id IN (#{condition}) AND jobs.deleted = 0 AND job_statuses.wildcard_on between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")
    

    condition2 = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.collect {|job| job.id}.join(",")

    unless condition2.blank?
      @jobs_purchased_profiles = PurchasedProfile.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    purchased_profiles.id,
                    MONTH(purchased_profiles.created_at) created_at_month,
                    YEAR(purchased_profiles.created_at) created_at_year,
                    DATE(purchased_profiles.created_at) created_at,
                    purchased_profiles.created_at as date_create
                    from purchased_profiles
              WHERE
                (job_id IN (#{condition2}) AND purchased_profiles.deleted_at IS NULL AND purchased_profiles.payment_id != 0 AND purchased_profiles.created_at between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")
    else
      @jobs_purchased_profiles = ""
    end
    

    @jobs_new_facebook = Job.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    jobs.id,
                    MONTH(log_shares.created_at) created_at_month,
                    YEAR(log_shares.created_at) created_at_year,
                    DATE(log_shares.created_at) created_at,
                    log_shares.created_at as date_create
                    from jobs
                    join log_shares on jobs.id = log_shares.job_id
                    join employers on jobs.employer_id = employers.id
              WHERE
                (employers.id IN (#{condition}) AND jobs.deleted = 0 AND share_platform_id =#{SHARE_PLATFORM_FACEBOOK_ID} AND log_shares.created_at between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")

    @jobs_new_twitter = Job.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    jobs.id,
                    MONTH(log_shares.created_at) created_at_month,
                    YEAR(log_shares.created_at) created_at_year,
                    DATE(log_shares.created_at) created_at,
                    log_shares.created_at as date_create
                    from jobs
                    join log_shares on jobs.id = log_shares.job_id
                    join employers on jobs.employer_id = employers.id
              WHERE
                (employers.id IN (#{condition}) AND jobs.deleted = 0 AND share_platform_id =#{SHARE_PLATFORM_TWITTER_ID} AND log_shares.created_at between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")
              
    @jobs_new_linkedin = Job.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    jobs.id,
                    MONTH(log_shares.created_at) created_at_month,
                    YEAR(log_shares.created_at) created_at_year,
                    DATE(log_shares.created_at) created_at,
                    log_shares.created_at as date_create
                    from jobs
                    join log_shares on jobs.id = log_shares.job_id
                    join employers on jobs.employer_id = employers.id
              WHERE
                (employers.id IN (#{condition}) AND jobs.deleted = 0 AND share_platform_id =#{SHARE_PLATFORM_LINKEDIN_ID} AND log_shares.created_at between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")
              
    @jobs_new_email = Job.find_by_sql("SELECT
              count(a.id) as cnt, created_at_month, created_at_year, a.date_create
              FROM
                  (select
                    jobs.id,
                    MONTH(log_shares.created_at) created_at_month,
                    YEAR(log_shares.created_at) created_at_year,
                    DATE(log_shares.created_at) created_at,
                    log_shares.created_at as date_create
                    from jobs
                    join log_shares on jobs.id = log_shares.job_id
                    join employers on jobs.employer_id = employers.id
              WHERE
                (employers.id IN (#{condition}) AND jobs.deleted = 0 AND share_platform_id = 6 AND log_shares.created_at between '#{DateTime.now.utc - 12.months}' and '#{DateTime.now.utc}'))
              as a
              group by created_at_month, created_at_year order by created_at")
                                                             
  end
    
  def clear_payment_session
    session[:total_amount] = session[:paypal_amount] = session[:promotional_code_amount] = session[:promo_remaining_amt] = session[:promotional_code_id] = session[:paypal_success_msg] = session[:cc_success_msg] = nil
    session[:old_payment] = session[:promo_code_obj] = session[:pay_for] = session[:pay_job] = nil
  end
  
  def clear_job_view_pay
    session[:job_view_pay] = nil
  end
  
  def return_payment_obj_for_promo_code(total_amount,promotional_code_id,promotional_code_amount, purpose)
    Payment.new({ :amount_charged => total_amount,
        :paypal_amount=> 0.0,
        :payment_success =>true,
        :payment_purpose => purpose,
        :promotional_code_amount => promotional_code_amount ,
        :holder_name => "NA",
        :card_type=> "promo",
        :card_num => "NA",
        :cvv => "NA",
        :expiry_date=>"NA",
        :billing_address_one=> "NA",
        :billing_address_two=> "NA",
        :billing_city=> "NA",
        :billing_state=> "NA",
        :billing_zip=> "NA",
        :billing_country=> "NA",
        :promotional_code_id=> promotional_code_id,
        :payment_mode =>  $payment_mode[:promo_code]
      })
  end

  def return_payment_obj_for_hilo(total_amount, purpose)
    Payment.new({ :amount_charged => total_amount,
        :paypal_amount=> 0.0,
        :payment_success =>true,
        :payment_purpose => purpose,
        :promotional_code_amount => 0.0,
        :holder_name => "NA",
        :card_type=> "promo",
        :card_num => "NA",
        :cvv => "NA",
        :expiry_date=>"NA",
        :billing_address_one=> "NA",
        :billing_address_two=> "NA",
        :billing_city=> "NA",
        :billing_state=> "NA",
        :billing_zip=> "NA",
        :billing_country=> "NA",
        :payment_mode =>  $payment_mode[:hilo_transaction],
        :discount_amount => 0.0,
        :credit_amount => total_amount
      })
  end
  
  def return_payment_mode(paypal_method = nil)
    case paypal_method
    when $payment_mode[:pro]
      if !session[:promotional_code_amount].nil? and session[:promotional_code_amount] > 0
        return $payment_mode[:pro_promo]
      else
        return $payment_mode[:pro]
      end
    when "express"
      if !session[:promotional_code_amount].nil? and session[:promotional_code_amount] > 0
        return $payment_mode[:express_promo]
      else
        return $payment_mode[:express]
      end
    when "ref_transaction"
      if !session[:promotional_code_amount].nil? and session[:promotional_code_amount] > 0
                  
        return $payment_mode[:ref_transaction_promo]
      else
        return $payment_mode[:ref_transaction]
      end
    when nil
      return $payment_mode[:promo_code]
    end
  end
  
  def return_job_view_payment_mode(job_view_hash,paypal_method = nil)
    case paypal_method
    when $payment_mode[:pro]
      if !job_view_hash.nil? and job_view_hash[:promotional_code_amount] > 0
        return $payment_mode[:pro_promo]
      else
        return $payment_mode[:pro]
      end
    when "express"
      if !job_view_hash.nil? and job_view_hash[:promotional_code_amount] > 0
        return $payment_mode[:express_promo]
      else
        return $payment_mode[:express]
      end
    when "ref_transaction"
      if !job_view_hash.nil? and job_view_hash[:promotional_code_amount] > 0
        return $payment_mode[:ref_transaction_promo]
      else
        return $payment_mode[:ref_transaction]
      end
    when nil
      return $payment_mode[:promo_code]
    end
  end

  def return_job_view_payment_mode_csv2(promo_code_amount,paypal_method = nil)
    case paypal_method
    when $payment_mode[:pro]
      if promo_code_amount > 0
        return $payment_mode[:pro_promo]
      else
        return $payment_mode[:pro]
      end
    when "express"
      if promo_code_amount > 0
        return $payment_mode[:express_promo]
      else
        return $payment_mode[:express]
      end
    when "ref_transaction"
      if promo_code_amount > 0
        return $payment_mode[:ref_transaction_promo]
      else
        return $payment_mode[:ref_transaction]
      end
    when nil
      return $payment_mode[:promo_code]
    end
  end
  
  
  def authorize_admin
    if session[:admin].blank?
      redirect_to :controller=>"/admin/admin_login"
      return false
    end
  end
  
  def current_app_domain_url
    @current_app_domain_url  = "https://" + request.env["HTTP_HOST"]
  end
  
  def current_user
    if session[:job_seeker]
      return session[:job_seeker]
    end
    if session[:employer]
      return session[:employer]
    end
    if session[:administrator]
      session[:administrator]
    end
  end
  
  def required_loggedin_job_seeker
    if session[:job_seeker].nil?
      redirect_to :controller=>:home
      return
    else
      js = JobSeeker.find_by_id(session[:job_seeker].id)
      if js.nil?
        clear_session_on_logout
        if request.xhr?
          render '/account/logout_career_seeker', :formats=>[:js], :layout=>false
        else
          redirect_to :controller=>:home,:action=>:index
          return
        end
      end
    end

  end
  
  def required_loggedin_employer
    if session[:employer].blank?
      redirect_to :controller=>:home
      return
    end
  end
    
  def job_seeker_with_complete_registration
    unless session[:job_seeker].nil?
      js = JobSeeker.find_by_id(session[:job_seeker].id)
      if js.nil?
        clear_session_on_logout
        if request.xhr?
          render '/account/logout_career_seeker', :formats=>[:js], :layout=>false
        else
          redirect_to :controller=>:home,:action=>:index
        end
      elsif session[:job_seeker].activated == false or session[:job_seeker].completed_registration_step < PAYMENT_STEP
        redirect_to redirect_to_registration_step
      end
    else
      redirect_to redirect_to_registration_step
    end
  end
  
  def employer_with_complete_registration
    if session[:employer].blank? or session[:employer].activated == false or session[:employer].completed_registration_step < EMPLOYER_PAYMENT_STEP
      redirect_to redirect_to_employer_registration_step
      return
    end
  end
    
  def reload_seeker_session(job_seeker = nil)
    session[:job_seeker] = (job_seeker.nil? ?  JobSeeker.where(:id=>session[:job_seeker].id).first : JobSeeker.where(:id=>job_seeker.id).first)
    clear_employer_session()
    clear_admin_session()
  end
  
  def reload_employer_session(employer = nil)
    session[:employer] = (employer.nil? ?  Employer.where(:id => session[:employer].id).first : Employer.where(:id => employer.id).first)
    clear_seeker_session()
    clear_admin_session()
  end
    
  def reload_admin_session(admin = nil)
    session[:admin] = (admin.nil? ?  Admin.find(session[:admin].id) : Admin.find(admin.id))
    clear_seeker_session()
    clear_employer_session()
  end
  
  def get_remote_ip
    (request.remote_ip.index("127") == 0)  ? "192.168.1.2" : request.remote_ip
  end
  
  def log_shared_job_traffic
    if session[:track_shared_job_id] and session[:track_shared_platform_id] and session[:job_seeker]
      LogJobShare.log_job(session[:track_shared_job_id],session[:track_shared_platform_id],session[:job_seeker].id)
    end
      
  end
  
  def log_shared_job_traffic_hilo(job_id)
    LogJobShare.log_job(job_id, 5, session[:job_seeker].id)
  end

  def log_channel_manager
    if session[:track_shared_job_id] and session[:track_shared_platform_id]
      ChannelManager.log_entry(session[:track_shared_job_id], session[:track_shared_platform_id])
    end
  end
  def log_recruiting_manager(from = nil)
    if session[:track_shared_company_id] and session[:track_shared_platform_id]
      if from.nil?
        CompanyPosting.log_entry(session[:track_shared_company_id], session[:track_shared_platform_id])
      else
        CompanyPosting.log_entry(session[:track_shared_company_id], "4")
      end
    end
  end

  def log_channel_mangaer_hilo(job_id, platform_id)
    ChannelManager.log_entry(job_id, platform_id)
  end
  
  def clear_session_on_logout
    suspended_user = session[:user_suspended] if session[:user_suspended] == true
    deleted_user = session[:user_deleted] if session[:user_deleted] == true
    language_session = session[:locale]
    session[:last_login] = nil
    clear_seeker_session
    clear_employer_session
    clear_admin_session
    clear_payment_session
    clear_sharing_session
    clear_xref_session
    session[:pass_through] = nil
    session[:auth_pass] = nil
    session[:account_auth] = nil
    session[:upload_failure] = nil
    session[:track_shared_job_id] = nil
    session[:track_shared_company_id] = nil
    session[:track_shared_platform_id] = nil
    session[:discount_amount] =  nil
    session[:credit_amount] =  nil
    session[:credit_total] = nil
    session[:one_click_card] = nil
    session[:legacy_data_cs] = nil
    session[:dummy] = nil
    clear_persist_sessions
    reset_session
    session[:user_suspended] = suspended_user if suspended_user == true
    session[:user_deleted] = deleted_user if deleted_user == true
    session[:locale] = language_session
  end
  
  def clear_persist_sessions
    session[:area_code] = nil
    session[:phone_one] = nil
    session[:contact_email] = nil
    session[:summary] = nil
    session[:armed] = nil
    session[:preferred_contact] = nil
    session[:flag] = nil
    session[:error] = nil
  end
  
  def clear_employer_session
    session[:employer] = nil
  end
  
  def clear_seeker_session
    session[:job_seeker] = nil
  end
  
  def clear_admin_session
    session[:administrator] = nil
  end

  def clear_sharing_session
    session[:linkedin_access_token] = session[:linkedin_secret_token] = session[:access_token] = session[:secret_token] = nil
  end
  
  def redirect_to_registration_step(from = nil)
    if session[:job_seeker].blank?
      return {:controller=>:home,:action=>:index}
    end
      
    case session[:job_seeker].completed_registration_step.to_i
    when ACCOUNT_SETUP_STEP
      capture_bridge_response
      return {:controller => :questionnaire}
    when PAIRING_BASICS_STEP
      capture_bridge_response
      return {:controller => :payment}
    when  PAIRING_CREDENTIALS_STEP
      capture_bridge_response
      return {:controller => :pairing_profile, :action=> :basics}
    when QUESTIONNAIRE_STEP
      capture_bridge_response
      return {:controller => :pairing_profile, :action => :credentials, :id => from }
    when PAYMENT_STEP
      return {:controller => :account,:action=>:index}
    else
      capture_bridge_response
      return {:controller => :job_seeker,:action=>:new}
    end
  end

  def capture_bridge_response
    if not session[:job_seeker].blank?
      session[:job_seeker].bridge_response = session[:bridge_response] if not session[:bridge_response].nil?
      session[:job_seeker].track_shared_job_id = session[:track_shared_job_id] if not session[:track_shared_job_id].nil?
      session[:job_seeker].track_shared_company_id = session[:track_shared_company_id] if not session[:track_shared_company_id].nil?
      session[:job_seeker].track_platform_id = session[:track_shared_platform_id] if not session[:track_shared_platform_id].nil?
      session[:job_seeker].save(:validate => false)
      session[:bridge_response] = nil
      session[:track_shared_job_id] = nil
      session[:track_shared_platform_id] = nil
      session[:job_not_active] = nil
      session[:company_not_active] = nil
      session[:track_shared_company_id] = nil
    end
  end
    
  def redirect_to_employer_registration_step
    if session[:employer].blank?
      return root_path
    end
      
    case session[:employer].completed_registration_step.to_i
    when EMPLOYER_ACCOUNT_SETUP_STEP
      return {:controller => :employer_payment,:action=>:index}
    when EMPLOYER_PAYMENT_STEP
      return {:controller => :employer_account,:action=>:index}
    else
      return {:controller => :employer,:action=>:new}
    end
  end


  def json_from_error_arr (err)
    json_arr = []
    err.each{|ele|
      json_arr << "{'key':'#{ele[0]}', 'msg':'#{ele[1]}'}"
    }
    return  "[" + json_arr.join(",") + "]"
  end
  
  def create_language_hash(lang_hash)
    ret_hash = {}
      
    if not lang_hash.blank?
      lang_arr = lang_hash.split(",")
      lang_arr.each{|lang|
        lang_id_name_arr = lang.split("__")
        ret_hash.update({lang_id_name_arr[0] => lang_id_name_arr[1]})
      }
    end
      
    return ret_hash
  end
  
  def add_remove_desired_employment
    JobSeekerDesiredEmployment.delete_all("job_seeker_id = '#{session[:job_seeker].id}'")
    if not params[:desired_employment_ids].blank?
      for val in params[:desired_employment_ids].split(",")
        begin
          DesiredEmployment.find(val)
          @job_seeker.job_seeker_desired_employments << JobSeekerDesiredEmployment.new({:desired_employment_id =>val})
        rescue ActiveRecord::RecordNotFound
        end
      end
    end
  end
    
  def add_remove_desired_location
    JobSeekerDesiredLocation.delete_all("job_seeker_id = '#{session[:job_seeker].id}'")
    if not params[:desired_location_ids].blank?
      for val in params[:desired_location_ids].split(",")
        begin
          DesiredLocation.find(val)
          if val=="1"
            @job_seeker.job_seeker_desired_locations << JobSeekerDesiredLocation.new({
                :desired_location_id =>val,
                :city => params[:desired_city],
                :latitude => params[:latitude],
                :longitude => params[:longitude]})
          else
            @job_seeker.job_seeker_desired_locations << JobSeekerDesiredLocation.new({:desired_location_id =>val})
          end
        rescue ActiveRecord::RecordNotFound
        end
      end
    end
  end
  
  def empty_all_payment_sessions
    if !session[:pay_job].nil?
      session[:pay_job] = nil
    end
    
    if !session[:old_payment].nil?
      session[:old_payment] = nil
    end
    
    if !session[:promo_code_obj].nil?
      session[:promo_code_obj] = nil
    end
    
    if !session[:pay_for].nil?
      session[:pay_for] = nil
    end
  end
  
  def render_error(exception)
    logger.error "Error caught " + exception.to_s
    redirect_to :controller => :app_error
  end

  def render_not_found(exception)
    logger.error "Error caught " + exception.to_s
    redirect_to :controller => :app_error
  end

  private

  def recruiting_manager_chat_data(pos='-1')
    reload_employer_session
    pos = pos.to_s
    @posting_record = CompanyPosting.find_by_company_id(session[:employer].company_id)
    if @posting_record.nil?
      @posting_record = CompanyPosting.create(:company_id=>session[:employer].company_id)
    end
    if pos == "-1"
      ancestors = session[:employer].ancestor_ids.join(",")
      subtree = session[:employer].subtree_ids.join(",")
      if not ancestors.blank?
        jobs_list = Job.where("employer_id NOT IN (#{ancestors}) AND employer_id IN (#{subtree}) AND deleted = 0")
      else
        jobs_list = Job.where("employer_id IN (#{subtree}) AND deleted = 0")
      end
    elsif pos == "0"
      jobs_list = Job.where("employer_id IN (#{session[:employer].id}) AND deleted = 0")
    else
      jobs_list = Job.where("employer_id IN (#{pos}) AND deleted = 0")
    end
    jobs_id_array = Array.new
    jobs_list.each do |job|
      jobs_id_array << job.id
    end
    jobs_id = jobs_id_array.join(',')
    @channel_record = nil
    @channel_record = ChannelManager.where("job_id IN (#{jobs_id})").all if not jobs_id.blank?

    @hilo_count = 0
    @url_count = 0
    @facebook_count = 0
    @twitter_count = 0
    @linkedin_count = 0

    if not @channel_record.nil?
      @channel_record.each do |t|
        @hilo_count = @hilo_count + t.hilo_count
        @url_count = @url_count + t.url_count
        @facebook_count = @facebook_count + t.facebook_count
        @twitter_count = @twitter_count + t.twitter_count
        @linkedin_count = @linkedin_count + t.linkedin_count
      end
    end
  end

  def sunspot_string(str)
    arr = str.split""
    flag = false
    arr.each_with_index do |val,i|
      if val == '"'
        if flag
          flag = false
        else
          flag = true
        end
      end
      if val == ',' and not flag
        arr[i] = ' AND '
      end
    end
    sunspot_str = arr.join""
    return sunspot_str
  end
  
end