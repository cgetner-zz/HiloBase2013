# coding: UTF-8
require 'csv'
require 'email_veracity'
class EmployerAccountController < ApplicationController
  
  layout "dashboard"
  before_filter :clear_xref_session, :except=>[:fetch_notifications_count]
  before_filter :employer_with_complete_registration  
  before_filter :validate_job_for_employer,:only =>[:index]
  before_filter :get_left_panel_jobs_recruting_manager,:only=>[:recruiting_manager]
  before_filter :get_pos_profile_chart_data,:only => [:index]
  before_filter :check_expired_jobs, :only => [:index]
  before_filter :check_for_deleted_users
  before_filter :check_for_suspended_users
  before_filter :check_job_seeker_deleted_viewed_profile, :only => [:view_seeker_profile]
  
  def index
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.select("jobs.name, job_seekers.first_name, job_seekers.last_name,
    employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.id,
    employer_alerts.created_at AS created_at").joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id
    LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("(jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = #{session[:employer].id})
    AND employer_alerts.read = ? AND employer_alerts.new = ? AND employer_alerts.purpose <> ?
    AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.created_at desc").all.size
    reload_employer_session
    if params[:selected].present?
      if session[:employer].account_type_id != 3
        case params[:selected].to_i
        when -1
          ancestors = session[:employer].ancestor_ids
          subtree = session[:employer].subtree_ids
          @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
        when 0
          ancestors = session[:employer].ancestor_ids
          descendants = session[:employer].descendant_ids
          @jobs = session[:employer].get_my_positions(ancestors, descendants)
        else
          begin
            emp = Employer.find_by_id(params[:selected].to_i)
            ancestors = emp.ancestor_ids
            subtree = emp.subtree_ids
            arr = emp.last_name.split""
            str_new = arr[0] + "."
            @name = emp.first_name + " " + str_new
            @jobs = emp.get_jobs_with_group(ancestors, subtree)
          rescue
            ancestors = session[:employer].ancestor_ids
            subtree = session[:employer].subtree_ids
            @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
          end
        end
      else
        ancestors = session[:employer].ancestor_ids
        descendants = session[:employer].descendant_ids
        @jobs = session[:employer].get_my_positions(ancestors, descendants)
      end
    else
      if session[:employer].account_type_id != 3
        subtree = session[:employer].subtree_ids
        ancestors = session[:employer].ancestor_ids
        @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      else
        ancestors = session[:employer].ancestor_ids
        descendants = session[:employer].descendant_ids
        @jobs = session[:employer].get_my_positions(ancestors, descendants)
      end
    end
    #@arr = session[:employer].self_group_id
    #@job_statuses = Job.get_job_status(@jobs, session[:employer].id)
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @current_employer= Employer.where("id=?", session[:employer].id).first
    #@employer_category_size = Employer.select("company_groups.id as company_groups_id, company_groups.name as name").where("employers.id=? and company_groups.deleted=?", session[:employer].id, false).joins("join companies on employers.company_id = companies.id join company_groups on companies.id = company_groups.company_id").all.size
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size

    #subtree size:
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
  end

  def add_folder_div
    render :partial=>'/employer_account/add_folder'
  end

  def invite
    address = EmailVeracity::Address.new(params[:invite_email].strip)
    if address.valid?
      company_name = session[:employer].company.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
      #ics
      bitly = Bitly.new($BITLY_KEY,$BITLY_SECRET)
      random_token = Company.fetch_random_token(session[:employer].company_id)
      link = bitly.shorten('https://thehiloproject.com/'+company_name+'/internal_candidate/'+session[:employer].company_id.to_s+'/'+random_token)
      #ics
      Notifier.invitation_ics_phase_two(params[:invite_email].strip,company_name,link.shorten).deliver
      render 'email_validation_success', :formats=>[:js], :layout=>false
    else
      render 'email_validation_failure', :formats=>[:js], :layout=>false
    end
  end

  def add_csv
    flag = 0
    logger.info "*************************************"
    logger.info File.extname(params[:csv].original_filename)
    logger.info params[:csv].tempfile
    logger.info params[:csv].content_type
    logger.info params[:csv].tempfile.path
    if File.extname(params[:csv].original_filename).to_s == '.csv'
      flag = 0
      company_name = session[:employer].company.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
      bitly = Bitly.new($BITLY_KEY,$BITLY_SECRET)
      random_token = Company.fetch_random_token(session[:employer].company_id)
      link = bitly.shorten('https://thehiloproject.com/'+company_name+'/internal_candidate/'+session[:employer].company_id.to_s+'/'+random_token)
      begin
        CSV.new(params[:csv].tempfile, {headers:false, row_sep: :auto}).each do |row|
          #logger.info "************************************#{row[0]}"
          0.upto(row.size-1) do |n|
            if row[n]
              address = EmailVeracity::Address.new(row[n].strip)
              if address.valid?
                flag = 1
                Notifier.invitation_ics_phase_two(row[n].strip,company_name,link.shorten).deliver
              else
                logger.info "*********************"
                logger.info row[n].strip
                if row[n].strip != ""
                  flag = 2
                  @context = row[n].strip
                  break
                end
              end
            end
          end
          if flag == 2
            break
          end
        end
      rescue CSV::MalformedCSVError
        flag = 0
      end
    end
    
    if flag == 1
      responds_to_parent do
        render 'csv_success', :formats=>[:js], :layout=>false
      end
    elsif flag == 2
      responds_to_parent do
        render 'csv_email_error', :formats=>[:js], :layout=>false
      end
    else
      responds_to_parent do
        render 'csv_failure', :formats=>[:js], :layout=>false
      end
    end
  end

  def show_ie_popup
    render 'show_ie_popup', :formats=>[:js], :layout=>false
  end

  def save_domain_name
    @success,@context,@domain = CompanyDomain.create_domain(session[:employer].company_id, params[:domain_name])
  end

  def search_filter
    if params[:search].present?
      sunspot_str = sunspot_string(params[:search])
      logger.info("************sunspot_str #{sunspot_str}")
      begin
        count = JobSeeker.count
        count = Job.count * count
        search = Sunspot.search [JobSeeker] do
          fulltext sunspot_str, :minimum_match => 1
          paginate :page => 1, :per_page => count
        end
        search_result = search.results
        @result_arr = Array.new()
        search_result.each do |post|
          @result_arr << post.id
        end
      rescue
        render '/position_profile/search_filter_exception_handling', :formats=>[:js], :layout=>false
        return
      end
    end
    render '/position_profile/search_filter', :formats=>[:js], :layout=>false
    return
  end

  def recruiting_manager
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.select("jobs.name, job_seekers.first_name, job_seekers.last_name,
    employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.id,
    employer_alerts.created_at AS created_at").joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id
    LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("(jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = #{session[:employer].id})
    AND employer_alerts.read = ? AND employer_alerts.new = ? AND employer_alerts.purpose <> ?
    AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.created_at desc").all.size
    reload_employer_session
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @current_employer= Employer.where("id=?", session[:employer].id).first
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size

    #subtree size:
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    if params[:selected].present?
      recruiting_manager_chat_data(params[:selected])
    else
      recruiting_manager_chat_data('-1')
    end
    @employer_privilege = session[:employer].company.employer_privileges.last
    #ics
    bitly = Bitly.new($BITLY_KEY,$BITLY_SECRET)
    random_token = Company.fetch_random_token(session[:employer].company_id)
    company = Company.find_by_id(session[:employer].company_id)
    company_name = company.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
    @ics_url = bitly.shorten('https://thehiloproject.com/'+company_name+'/internal_candidate/'+session[:employer].company_id.to_s+'/'+random_token)
    #ics
    render :layout=>"emp_channel_manager"
  end
  
  def save_alert
    employer = Employer.where(:id => session[:employer].id).first
    employer.alert_threshold = params[:alert_threshhold_val]
    employer.alert_method = params[:alert_method_val]
    employer.notification_email_time = DateTime.now if employer.notification_email_time.nil?
    employer.save(:validate => false)
    reload_employer_session
    render :text => "Saved"
  end

  def save_eeo_flag
    if session[:employer].account_type_id == 1 or session[:employer].account_type_id == 3
      employer = Employer.where(:id => session[:employer].id).first
      employer.company.graphical_content = true if params[:graphical_content_flag] == "true"
      employer.company.graphical_content = false if params[:graphical_content_flag] == "false"
      employer.company.save(:validate => false)
      render :text => "saved"
    else
      render :text => "access denied"
    end
  end


  def reset_notifications
    notifications = EmployerAlert.where("employer_alerts.new = ? AND employer_alerts.employer_id = ?", true, session[:employer].id).all
    notifications.each do |n|
      n.new = false
      n.save
    end
    render :text => "Done"
  end

  def profile_visits(sort, order, start=0, limit=5, selected = -1)
    reload_employer_session
    @ancestors = session[:employer].ancestor_ids
    @subtree = session[:employer].subtree_ids
    @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)
    #@job_statuses = Job.get_job_status(@jobs,session[:employer].id)
    @pos = selected.to_i
    order_new = ""
    if sort == "status"
      order_new = "job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    elsif sort == "vet"
      order_new = "job_seekers.armed_forces #{order}, vet #{order}"
    else
      order_new = "#{sort} #{order}"
    end
    case selected.to_i
    when -1
      condition = Employer.find(session[:employer].id).subtree_ids.join(",")
    when 0
      condition = session[:employer].id
    else
      begin
        condition = Employer.find(selected).subtree_ids.join(",")
      rescue
        condition = Employer.find(session[:employer].id).subtree_ids.join(",")
      end
    end
    
    @profile_visits = JobSeeker.select("DISTINCT job_seekers.id, if(job_seekers.company_id IS NULL, 0, 1) as internal,
        job_seekers.first_name, job_seekers.armed_forces,
        job_statuses.read, job_statuses.considering,
        job_statuses.interested,
        job_statuses.wild_card, jobs.name,
        jobs.id as job_id, jobs.armed_forces as vet,
        share_platforms.name as share_name,
        pairing_logics.pairing_value as pairing").where("job_seekers.activated = 1 and
        jobs.deleted = 0 and jobs.employer_id IN (#{condition}) and ((job_statuses.wild_card = 1) or (payment_id is not null))").joins("cross join jobs
        left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and jobs.id = job_statuses.job_id
        join employers on jobs.employer_id = employers.id
        left join purchased_profiles on purchased_profiles.company_id = #{session[:employer].company_id} and purchased_profiles.job_seeker_id = job_seekers.id
        and purchased_profiles.job_id = jobs.id and purchased_profiles.payment_id != 0
        join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id and (jobs.id = pairing_logics.job_id)
        left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and jobs.id = log_job_shares.job_id
        left join share_platforms on log_job_shares.share_platform_id = share_platforms.id").order("#{order_new}").limit("#{start},#{limit}").all

  end

  def profile_visits_filter(sort, order, start=0, limit=5, selected = -1)
    reload_employer_session
    @ancestors = session[:employer].ancestor_ids
    @subtree = session[:employer].subtree_ids
    @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)
    @pos = selected.to_i
    order_new = ""
    if sort == "status"
      order_new = "job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    elsif sort == "vet"
      order_new = "job_seekers.armed_forces #{order}"
    else
      order_new = "#{sort} #{order}"
    end

    case selected.to_i
    when -1
      condition = Employer.find(session[:employer].id).subtree_ids.join(",")
    when 0
      condition = session[:employer].id
    else
      begin
        condition = Employer.find(selected).subtree_ids.join(",")
      rescue
        condition = Employer.find(session[:employer].id).subtree_ids.join(",")
      end
    end

    if session[:employer].account_type_id != 3
      condition2 = session[:employer].root.subtree_ids.join(',')
    else
      condition2 = session[:employer].id
    end

    @profile_visits = JobSeeker.select("DISTINCT job_seekers.id,if(job_seekers.company_id IS NULL, 0, 1) as internal,
        job_seekers.first_name, job_seekers.armed_forces,
        job_statuses.read, job_statuses.considering,
        job_statuses.interested,
        job_statuses.wild_card, jobs.name,
        jobs.id as job_id, jobs.armed_forces as vet,
        share_platforms.name as share_name,
        pairing_logics.pairing_value as pairing").where("job_seekers.activated = 1 and
        jobs.deleted = 0 and jobs.employer_id IN (#{condition}) and ((job_statuses.wild_card = 1) or (payment_id is not null))").joins("cross join jobs
        left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and jobs.id = job_statuses.job_id
        join employers on jobs.employer_id = employers.id
        left join purchased_profiles on purchased_profiles.company_id = #{session[:employer].company_id} and purchased_profiles.job_seeker_id = job_seekers.id
        and purchased_profiles.job_id = jobs.id and purchased_profiles.payment_id != 0
        join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id and (jobs.id = pairing_logics.job_id)
        left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and jobs.id = log_job_shares.job_id
        left join share_platforms on log_job_shares.share_platform_id = share_platforms.id").where("job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id in (#{session[:employer].company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{condition2}))").order("#{order_new}").limit("#{start},#{limit}").all
  end

  def get_profile_visits
    params[:start] ||= 0
    params[:limit] ||= 10
    @start = params[:start]
    @limit = params[:limit]
      
    params[:job_type] ||= "dashboard"
    params[:scroll] ||= false
      
    @order = params[:order].to_s == "desc" ? "desc" : "asc"
    @sort = params[:sort] ||= "pairing"
    support_sort = ["name", "pairing", "first_name", "share_name", "status", "vet"]
    @sort = support_sort.include?(@sort) ? @sort : "pairing"
    if params[:filter].to_s == "0"
      profile_visits(@sort, @order, @start, @limit, params[:pos])
    elsif params[:filter].to_s == "1"
      profile_visits_filter(@sort, @order, @start, @limit, params[:pos])
    end
    @start = @start.to_i
    if params[:from] == "table_data"
      render :partial => "position_table_data", :layout => false
    else
      if params[:scroll]
        render :partial => "position_table_rows", :layout => false
      else
        render :partial => "position_table", :layout => false
      end
    end
    return
  end

  def load_notifications
    params[:start] ||= 0
    params[:limit] ||= 15
    params[:scroll] ||= false

    @legacy_jobs = Job.where(:deactivated_for_new_credential=>false,:employer_id=>session[:employer].id).first

    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    if params[:start] == 0
      @notifications = EmployerAlert.select("jobs.name, job_seekers.first_name, job_seekers.last_name,
      employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.job_id, employer_alerts.deleted_employer_id,
      employer_alerts.id, employer_alerts.employer_job_activity, employer_alerts.company_group_id, employer_alerts.created_at AS created_at").joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id
      LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("(jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = ?) AND employer_alerts.read = ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, session[:employer].id, false, "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.id desc").limit("#{params[:limit]}")
    else
      @notifications = EmployerAlert.select("jobs.name, job_seekers.first_name, job_seekers.last_name,
      employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.job_id, employer_alerts.deleted_employer_id,
      employer_alerts.id, employer_alerts.employer_job_activity, employer_alerts.company_group_id, employer_alerts.created_at AS created_at").joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id
      LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("(jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = ?) AND employer_alerts.read = ? AND employer_alerts.id < ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, session[:employer].id, false,params[:start], "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.id desc").limit("#{params[:limit]}")
    end

    if params[:scroll]
      render :partial => "notifications_rows", :locals => {:notifications => @notifications}
    else
      render :partial => "notifications", :locals => {:notifications => @notifications}  
    end
  end
  
  def fetch_notifications_count
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.select("jobs.name, job_seekers.first_name, job_seekers.last_name,
    employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.id,
    employer_alerts.created_at AS created_at").joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id
    LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("(jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = #{session[:employer].id})
	  AND employer_alerts.read = ? AND employer_alerts.new = ? AND employer_alerts.purpose <> ?
	  AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.created_at desc").all.size
    render :text=>@notifications_count    
  end
  
  def delete_notifications
    id = params[:id]
    params[:start] ||= 0
    params[:limit] ||= 1
    @notifications = EmployerAlert.where("id = ?", id).first #, :conditions => "read_unread is null or read_unread = 0") #add conditions here
    if !@notifications.nil?
      @notifications.read = true
      @notifications.save
    end
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications = EmployerAlert.select("jobs.name, job_seekers.first_name, job_seekers.last_name,
    employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.job_id, employer_alerts.deleted_employer_id,
    employer_alerts.id, employer_alerts.employer_job_activity, employer_alerts.company_group_id, employer_alerts.created_at AS created_at").joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id
    LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("(jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = ?) AND employer_alerts.read = ? AND employer_alerts.id < ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, session[:employer].id, false,params[:start], "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.id desc").limit("#{params[:limit]}")
    #@notifications = EmployerAlert.select("jobs.name, job_seekers.first_name, job_seekers.last_name,
    #employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.job_id, employer_alerts.deleted_employer_id,
    #employer_alerts.id, employer_alerts.employer_job_activity, employer_alerts.company_group_id, employer_alerts.created_at AS created_at").joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id
    #LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("(jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = ?) AND employer_alerts.read = ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, session[:employer].id, false, "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.id desc").limit("#{params[:limit]}").all
    render :partial => "notifications_rows", :locals => {:notifications => @notifications}  
  end


  def company_profile
    @employer = Employer.where("id = ? ", session[:employer].id)
    @company = @employer.company
    @company = Company.new if @company.blank?
    @ownership_arr = OwnerShipType.find(:all).collect{|o| o.id}
  end
  
  def save_company_profile
    @employer = Employer.where("id = ? ", session[:employer].id)
      
    @company = @employer.create_my_company(params[:company][:name],session[:employer].id,params[:company])
    if @company.errors.length > 0
      @company.errors.each{|k,v|
        @error_arr  << [k,v]
      }
                                
      @error_json = json_from_error_arr(@error_arr )
      @ownership_arr = OwnerShipType.find(:all).collect{|o| o.id}
      render :action=>"company_profile"
      return
    else
      @employer.set_company_id_if_empty(@company.id)
      reload_employer_session()
      redirect_to :controller => :employer_account,:action=>:company_profile
      return
    end
  
  end

  def candidate_profile
    reload_employer_session
    @ancestors = session[:employer].ancestor_ids
    @subtree = session[:employer].subtree_ids
    @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)
  end

  def view_seeker_profile
    job_id = params[:job_id]
    @job_seeker = JobSeeker.where(:id=>params[:seeker_id]).first

    @job_seeker_status = JobStatus.where(:job_id=>params[:job_id],:job_seeker_id=>params[:seeker_id]).first

    @job = Job.select("jobs.*, pairing_logics.pairing_value as pairing").joins("join pairing_logics on pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id = #{params[:seeker_id]}").where("jobs.id = '#{params[:job_id]}'").first

    @job_seeker_languages = JobSeekerLanguage.select("languages.*,job_seeker_languages.*").joins("inner join languages on languages.id = job_seeker_languages.language_id").where("job_seeker_languages.job_seeker_id = ?", params[:seeker_id]).all
    @desired_emp = @job.desired_employments.collect{|d| d.name}.join(", ")

    @job_seeker_roles = OccupationData.find_by_sql("SELECT `occupation_data`.`title` as `title`, `added_roles`.`education_level_id` as `education_level_id`, `added_roles`.`experience_level_id` as `experience_level_id` FROM `occupation_data` INNER JOIN `added_roles` ON `occupation_data`.`onetsoc_code` = `added_roles`.`code` WHERE `added_roles`.`adder_id` = #{@job_seeker.id} AND `added_roles`.`adder_type` = 'JobSeeker' ORDER BY `added_roles`.`id`")
    @job_seeker_degree = Degree.find_by_sql("SELECT `degrees`.`name` as `name` FROM `degrees` INNER JOIN `added_degrees` ON `degrees`.`id` = `added_degrees`.`degree_id` WHERE `added_degrees`.`adder_id` = #{@job_seeker.id} AND `added_degrees`.`adder_type` = 'JobSeeker'")

    @selected_certificates = NewCertificate.find_by_sql("SELECT `new_certificates`.`certification_name` as `name`, `job_seeker_certificates`.`order` as `order` FROM `new_certificates` INNER JOIN `job_seeker_certificates` ON `new_certificates`.`id` = `job_seeker_certificates`.`new_certificate_id` WHERE `job_seeker_certificates`.`job_seeker_id` = #{@job_seeker.id}")
    @selected_licenses = License.find_by_sql("SELECT `licenses`.`license_name` as `name`, `job_seeker_certificates`.`order` as `order` FROM `licenses` INNER JOIN `job_seeker_certificates` ON `licenses`.`id` = `job_seeker_certificates`.`license_id` WHERE `job_seeker_certificates`.`job_seeker_id` = #{@job_seeker.id}")
    temp_hash_c = {}
    temp_hash_l = {}
    @selected_certificates.each{|c|
      k = c.order
      v = c.name
      temp_hash_c.update({k=>v})
    }
    @selected_licenses.each{|c|
      k = c.order
      v = c.name
      temp_hash_l.update({k=>v})
    }
    @new_selected_certificates = []
    @new_selected_licenses = []
    temp_hash_c.keys.sort.each{|c|
      @new_selected_certificates<<temp_hash_c[c]
    }
    temp_hash_l.keys.sort.each{|c|
      @new_selected_licenses<<temp_hash_l[c]
    }
    @job_certifications = @new_selected_certificates
    @job_licenses = @new_selected_licenses

    @job_seeker_certifications = @new_selected_certificates
    @job_seeker_licenses = @new_selected_licenses
    #@job_certifications = @job_seeker.certificates
    
    @job_seeker_birkman_detail = @job_seeker.job_seeker_birkman_detail
    @min=@job_seeker.minimum_compensation_amount
    @compensation_range=$compensation_values
    @max =  maximum_compensation(@compensation_range,@min)
    PurchasedProfile.log_employer_view(params[:job_id], params[:seeker_id], params[:emp_id])
    render 'view_seeker_profile', :formats=>[:js], :layout=>false
  end

  def request_pdf
    job_seeker_id = params[:job_seeker_id]
    if(job_seeker_id.to_i == 0)
      render :nothing => true
    end
    file_name="#{Rails.root}/assets/system/resumes/#{job_seeker_id}/original/"+JobSeeker.where("id = ? ", params[:job_seeker_id]).resume_file_name
    if File.exists?(file_name)
      render :file => "/employer_account/download_pdf?job_seeker_id=#{job_seeker_id}";
      #          render :update do |page|
      #                page.call "birkman_report_employer.download(#{params[:job_seeker_id]})"
      #          end
    end
    #
    #      render :update do |page|
    #          page.call "birkman_report_employer.pending"
    #      end
    return
  end

  def download_pdf
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    file_name="#{Rails.root}/assets/system/resumes/#{params[:job_seeker_id]}/original/"+JobSeeker.where("id = ? ", params[:job_seeker_id]).resume_file_name
    if File.exists?(file_name)
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"Hilo_CFG.pdf"
    else
      render :text=>"File not found"
      return
    end
  end

  def maximum_compensation(compensation,min)
    counter = 0
    while counter < compensation.size
      if(compensation[counter]==min)
        break
      else
        counter = counter+1
      end
    end
    return compensation[counter+2]
  end

  def check_expired_jobs
    jobs= Job.where("employer_id = ? and active = ?", session[:employer].id, true)
    jobs.each do |job|
      if job.expire_at < Time.now
        posting_record = Posting.where("job_id = ?", job.id).first
        job.active = false
        posting_record.hilo_share = false
        posting_record.save
        job.save
      end
    end
  end

  def get_left_panel_jobs_recruting_manager
    reload_employer_session
    if !session[:employer].blank?
      if params[:selected].present?
        if session[:employer].account_type_id != 3
          case params[:selected].to_i
          when -1
            ancestors = session[:employer].ancestor_ids
            subtree = session[:employer].subtree_ids
            @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
          when 0
            ancestors = session[:employer].ancestor_ids
            descendants = session[:employer].descendant_ids
            @jobs = session[:employer].get_my_positions(ancestors, descendants)
          else
            begin
              emp = Employer.find_by_id(params[:selected].to_i)
              ancestors = emp.ancestor_ids
              subtree = emp.subtree_ids
              arr = emp.last_name.split""
              str_new = arr[0] + "."
              @name = emp.first_name + " " + str_new
              @jobs = emp.get_jobs_with_group(ancestors, subtree)
            rescue
              ancestors = session[:employer].ancestor_ids
              subtree = session[:employer].subtree_ids
              @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
            end
          end
        else
          ancestors = session[:employer].ancestor_ids
          descendants = session[:employer].descendant_ids
          @jobs = session[:employer].get_my_positions(ancestors, descendants)

        end
      else
        if session[:employer].account_type_id != 3
          subtree = session[:employer].subtree_ids
          ancestors = session[:employer].ancestor_ids
          @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
        else
          ancestors = session[:employer].ancestor_ids
          descendants = session[:employer].descendant_ids
          @jobs = session[:employer].get_my_positions(ancestors, descendants)
        end
      end
    else
      redirect_to :controller => "login", :action => "logout"
    end
  end
end
