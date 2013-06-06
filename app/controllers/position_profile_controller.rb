# coding: UTF-8

class PositionProfileController < ApplicationController
  layout "dashboard"

  before_filter :clear_xref_session, :except => [:xref, :get_xref_data]
  before_filter :xref_login_required, :only=>[:xref]
  before_filter :redirect_if_employer_has_no_jobs, :only=>[:xref]
  before_filter :employer_with_complete_registration
  before_filter :check_employer_job_save_permission, :except => :delete_attachment
  #:only => [:workenv, :employer_save_credentials, :create_new_emp_profile, :save_work_and_role_env_questions, :show_job_preview, :show_job_details, :delete_job]
  before_filter :validate_job_for_employer,:only =>[:edit,:basics,:save_basics,:work_env,:role,:save_credentials,:view,:candidate_pool,:profile,:new_employer_profile,:new_work_env, :get_candidate_pool_data, :get_candidate_pool, :get_xref, :search_filter]
  before_filter :check_category_status, :only => [:new_employer_profile, :create_new_emp_profile]
  before_filter :set_session_selected_xref, :only => [:xref]
  before_filter :get_left_panel_jobs,:only=>[:new, :create,:edit,:basics,:work_env,:role,:credentials,:view,:xref,:profile]
  before_filter :get_left_panel_jobs_candidate_pool,:only=>[:candidate_pool, :new_employer_profile]
  before_filter :get_candidate_pool_chart , :only =>[:candidate_pool]
  before_filter :validate_xref_request, :only => [:xref]
  before_filter :get_xref_pool_chart, :only => [:xref]
  before_filter :filter_basic_step,:only=>[:basics]
  before_filter :filter_workenv_step,:only=>[:work_env]
  before_filter :filter_role_step,:only=>[:role]
  before_filter :filter_credential_step,:only=>[:credentials]
  before_filter :validate_request, :only => [:new_employer_profile, :candidate_pool]
  before_filter :check_for_deleted_users
  before_filter :check_for_suspended_users
  
  
  def set_adv_pop_flag
    @employer = Employer.where("id=?", session[:employer].id).first
    if @employer.advanced_alert == false
      @employer.advanced_alert = true
    else
      @employer.advanced_alert = false
    end
    render :text => "DONE"
    @employer.save(:validate => false)
  end

  def search_filter
    if params[:search].present?
      sunspot_str = sunspot_string(params[:search])
      begin
        count = JobSeeker.count
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
  end
  
  def get_adv_pop_flag
    @employer = Employer.where("id=?", session[:employer].id).first
    render :text => @employer.advanced_alert
  end
  
  def new
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.find(:all,
      :select=>"jobs.name, job_seekers.first_name, employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.id, employer_alerts.created_at AS created_at" ,:joins => "JOIN jobs ON employer_alerts.job_id = jobs.id JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id",:conditions=>["jobs.employer_id IN (?) AND employer_alerts.read = ? AND employer_alerts.new = ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id],
      :group =>"employer_alerts.id",
      :order => "created_at desc").size

    @job = Job.new
    @employer = Employer.find(session[:employer].id)
    company_old = @employer.company
    @company = Company.new

    if not company_old.blank?
      @company.name = company_old.name
      @company.founded_in = company_old.founded_in
      @company.website = company_old.website
      @company.employee_strength = company_old.employee_strength
      @company.owner_ship_type_id = company_old.owner_ship_type_id
      @company.ticker_value = company_old.ticker_value
    end

    @job_location = JobLocation.new
    @ownerships = OwnerShipType.find(:all)
    @company_groups = session[:employer].get_groups
  end

  def show_job_preview
    @job = Job.find_by_id(params[:job_id])
    @job.overview_complete = true
    @job.save(:validate => false)
    @company = @job.company_for_job()
    @desired_emp = @job.desired_employments.collect{|d| d.name}.join(", ")
    @job_location = JobLocation.find(:first, :conditions=>["id = ?", @job.job_location_id])

    if @job.detail_preview == true and @job.overview_complete == true
      PairingLogic.delay.pairing_value_job(@job, "inactive_position_profile") if @job.profile_complete == false
      @job.profile_complete = true
      @job.save(:validate => false)
    end

    render 'after_preview_review', :formats=>[:js], :layout=>false
  end
  
  def show_job_details
    @job = Job.where(:id=>params[:job_id]).first
    @job.detail_preview = true
    @job.save(:validate => false)
    @x_score,@y_score = @job.work_env_score
    @emp_workenv_text = WorkenvQuestion.text_by_score(@x_score,@y_score)
    @x_score,@y_score = @job.role_score
    @emp_role_text = RoleQuestion.text_by_score(@x_score,@y_score )
    @job_location = JobLocation.where("id = ?", @job.job_location_id).first
    if not @job.job_location_id.blank?
      @address_str, @full_address = cs_form_address_str(@job_location)
    end
    @company = @job.company_for_job()
    @desired_emp = @job.desired_employments.collect{|d| d.name}.join(",")
    @job_desired_emp = @desired_emp.split(",")

    @job_roles = OccupationData.find_by_sql("SELECT `occupation_data`.`title` as `title` FROM `occupation_data` INNER JOIN `added_roles` ON `occupation_data`.`onetsoc_code` = `added_roles`.`code` WHERE `added_roles`.`adder_id` = #{@job.id} AND `added_roles`.`adder_type` = 'JobPosition' ORDER BY `added_roles`.`id`")
    @language_skills = @job.language_skill_proficiency
    #@job_certifications = @job.certification_required
    @selected_certificates = NewCertificate.find_by_sql("SELECT `new_certificates`.`certification_name` as `name`, `job_criteria_certificates`.`order` as `order` FROM `new_certificates` INNER JOIN `job_criteria_certificates` ON `new_certificates`.`id` = `job_criteria_certificates`.`new_certificate_id` WHERE `job_criteria_certificates`.`job_id` = #{@job.id}")
    @selected_licenses = License.find_by_sql("SELECT `licenses`.`license_name` as `name`, `job_criteria_certificates`.`order` as `order` FROM `licenses` INNER JOIN `job_criteria_certificates` ON `licenses`.`id` = `job_criteria_certificates`.`license_id` WHERE `job_criteria_certificates`.`job_id` = #{@job.id}")
    @required_certificates_arr = @job.job_criteria_certificates.map{|jc|  (jc.required_flag ? "1" : "0")}
    
    temp_hash = {}
    @selected_certificates.each{|c|
      k = c.order
      v = c.name
      temp_hash.update({k=>v})
    }
    @selected_licenses.each{|c|
      k = c.order
      v = c.name
      temp_hash.update({k=>v})
    }
    @new_selected_certificates = []
    temp_hash.keys.sort.each{|c|
      @new_selected_certificates<<temp_hash[c]
    }
    @job_certifications = @new_selected_certificates
    @job_degree = Degree.find_by_sql("SELECT `degrees`.`name` as `name`, `added_degrees`.`required_flag` as `flag` FROM `degrees` INNER JOIN `added_degrees` ON `degrees`.`id` = `added_degrees`.`degree_id` WHERE `added_degrees`.`adder_id` = #{@job.id} AND `added_degrees`.`adder_type` = 'JobPosition'")

    if @job.detail_preview == true and @job.overview_complete == true
      PairingLogic.delay.pairing_value_job(@job, "inactive_position_profile") if @job.profile_complete == false
      @job.profile_complete = true
      @job.save(:validate => false)
    end
    
    render 'after_position_review', :formats=>[:js], :layout=>false
  end
  
  def mark_emp_alert_unread
    e = EmployerAlert.find(params[:employer_alert_id])
    e.read = true
    e.save(:validate => false)
    render :text=>"done"
  end
  
  def edit
    @company = @job.company
    @job_location = @job.job_location
    @ownerships = OwnerShipType.find(:all)
    @company_groups = session[:employer].get_groups
    render :action =>:new
  end
  
  def create
    @employer = Employer.find(session[:employer].id)
    @company = @employer.create_or_update_company(params[:company_name],session[:employer].id)

    @company.founded_in = params[:company_founded_in]
    @company.website = params[:company_website]
    @company.employee_strength = params[:company_employee_strength]
    @company.owner_ship_type_id = params[:owner_ship_type_id]
    @company.ticker_value = params[:ticker_value]

    job_hash = {:name => params[:name], :employer_id => @employer.id ,:company_group_id => params[:company_group_id],:expire_at => params[:expire_at], :company_id => @company.id}

    if not params[:id].blank?
      @job = Job.find(params[:id])
    else
      @job = Job.new()
    end

    @job.attributes = job_hash

    @job_location = JobLocation.new({:street_one => params[:company_street_one],:street_two => params[:company_street_two],:city => params[:company_city],:zip_code => params[:company_zip]})

    if @job.save
      @company.save
      @job.add_responsibilities(params[:responsiblities])
      if @job_location.save
        @job.job_location_id = @job_location.id
        @job.save(:validate => false)
      end
      redirect_to :controller => :position_profile, :action => :edit, :id => @job.id
      return
    else
      @job.errors.each{|k,v|  @error_arr  << [k,v] }
      @error_json = json_from_error_arr(@error_arr )
      @ownerships = OwnerShipType.find(:all)
      @company_groups = session[:employer].get_groups
      render :action => :new
    end
  end

  #to add a category in CompanyGroup table
  def add_group
    reload_employer_session
    @employer_category = Employer.select("company_groups.name as name,company_groups.deleted as deleted").where("employers.id=? and company_groups.deleted = 0", Employer.find(session[:employer].id).id).joins("join companies on employers.company_id = companies.id join company_groups on companies.id = company_groups.company_id").all
    @cg = CompanyGroup.create(:name=>params[:add_group_field].to_s.strip, :company_id=>Employer.find(session[:employer].id).company_id, :employer_id=>session[:employer].id)
    @ancestors = Employer.find(session[:employer].id).ancestor_ids
    @descendants = session[:employer].descendant_ids
    @jobs = session[:employer].get_my_positions(@ancestors, @descendants)
    @job_statuses = Job.get_job_status(@jobs,session[:employer].id)
    @current_employer= Employer.where("id=?", session[:employer].id).first
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    if params[:from_popup] == "1"
      render 'add_category', :formats=>[:js], :layout=>false
    else
      render 'update_categories', :formats=>[:js], :layout=>false
    end
    return
    
  end
  
  def basics
    @selected_employment_ids  = @job.job_criteria_desired_employments.map{|j| j.desired_employment_id}
    @selected_location_ids  = @job.job_criteria_desired_locations.map{|j| j.desired_location_id}
        
    @compensation_range = $compensation_values
    @paidtime_range = $desired_paid_time
    @commute_range = $desired_commute_radius
    @desired_employments = DesiredEmployment.find(:all)
    @desired_locations = DesiredLocation.find(:all)
  end
  
  def save_basics
    @job.desired_commute_radius = params[:desired_commute_value]
    @job.desired_paid_offs = params[:desired_paidtime_value]
    @job.minimum_compensation_amount = params[:compensation_value]
                
    add_remove_job_criteria_employment()
    @job.basic_complete = true
    @job.save(:validate => false)
        
    redirect_to :controller => :position_profile,:action=>:basics,:id=>params[:id]
    return
  end

  def work_env
    x_score,y_score = @job.work_env_score
    @emp_workenv_text, @emp_workenv_color = WorkenvQuestion.text_and_color_by_score(x_score,y_score)
  end 

  def role
    x_score,y_score = @job.role_score
    @emp_role_color_text, @emp_role_color_val = RoleQuestion.text_and_color_by_score(x_score,y_score )
  end

  def credentials
    if params[:jid].to_i != 0
      @job = Job.where("jobs.id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(",")}) and jobs.deleted = ?", params[:jid], false).first
    end
    @selected_work_exp = @job.work_exp_value

    #Roles
    fetch_all_roles_for_logged_in_employer(@job.id)
    @career_clusters = CareerCluster.select("DISTINCT career_cluster")
    # certificates    
    #@selected_certificates = @job.certificates.map{|c| c.name}.join("_jucert_")
    @selected_certificates = NewCertificate.find_by_sql("SELECT `new_certificates`.`certification_name` as `name`, `job_criteria_certificates`.`order` as `order` FROM `new_certificates` INNER JOIN `job_criteria_certificates` ON `new_certificates`.`id` = `job_criteria_certificates`.`new_certificate_id` WHERE `job_criteria_certificates`.`job_id` = #{@job.id}")
    @selected_licenses = License.find_by_sql("SELECT `licenses`.`license_name` as `name`, `job_criteria_certificates`.`order` as `order` FROM `licenses` INNER JOIN `job_criteria_certificates` ON `licenses`.`id` = `job_criteria_certificates`.`license_id` WHERE `job_criteria_certificates`.`job_id` = #{@job.id}")
    @required_certificates_arr = @job.job_criteria_certificates.map{|jc|  (jc.required_flag ? "1" : "0")}.join(",")
    temp_hash = {}
    @selected_certificates.each{|c|
      k = c.order
      v = c.name
      temp_hash.update({k=>v})
    }
    @selected_licenses.each{|c|
      k = c.order
      v = c.name
      temp_hash.update({k=>v})
    }
    @new_selected_certificates = []
    temp_hash.keys.sort.each{|c|
      @new_selected_certificates<<temp_hash[c]
    }
    @new_selected_certificates = @new_selected_certificates.map{|c| c}.join("_jucert_")

    @selected_colleges = University.find_by_sql("SELECT `universities`.`institution` as `name` FROM `universities` INNER JOIN `added_universities` ON `universities`.`id` = `added_universities`.`university_id` WHERE `added_universities`.`adder_id` = #{@job.id} AND `added_universities`.`adder_type` = 'JobPosition'").map{|u| u.name}.join("_ecolg_")

    @work_exp_range = $work_exp_range

    @selected_languages = @job.job_criteria_languages.map{|lang| lang.language.name.to_s + "__" + lang.proficiency_val.to_s}.join(",")
    @required_languages_arr = @job.job_criteria_languages.map{|jl|  (jl.required_flag ? "1" : "0")}.join(",")
    @languages = Language.find(:all)

    @selected_degree = Degree.find_by_sql("SELECT `degrees`.`name` as `name` FROM `degrees` INNER JOIN `added_degrees` ON `degrees`.`id` = `added_degrees`.`degree_id` WHERE `added_degrees`.`adder_id` = #{@job.id} AND `added_degrees`.`adder_type` = 'JobPosition'").map{|d| d.name}.join(",")
    @degree_flag = Degree.find_by_sql("SELECT `added_degrees`.`required_flag` as `flag` FROM `degrees` INNER JOIN `added_degrees` ON `degrees`.`id` = `added_degrees`.`degree_id` WHERE `added_degrees`.`adder_id` = #{@job.id} AND `added_degrees`.`adder_type` = 'JobPosition'").first
    if @selected_degree.empty?
      @selected_degree = ""
    end
    if @degree_flag.nil?
      @degree_flag = ""
    else
      @degree_flag = @degree_flag.flag
    end
    
  end
    
  def save_credentials
    @job.work_exp_value = params[:workexp_value]
    cert_names = params[:certificate_param].blank?  ? [] : params[:certificate_param].split("_jucert_")
    required_certificate_flag = params[:required_certificates].blank? ? [] : params[:required_certificates].split(",")
    @job.add_certificates(cert_names,session[:employer].id,required_certificate_flag)
    prof_names = params[:proficiency_param].blank?  ? [] : params[:proficiency_param].split("_juprof_")
    @job.add_proficiencies(prof_names)
    required_languages_flag = params[:required_languages].blank? ? [] : params[:required_languages].split(",")
    @job.add_languages_new(params[:selected_languages], required_languages_flag)
    @job.credential_complete = true
    @job.save(:validate => false)
          
    redirect_to :controller => :position_profile,:action=>:credentials,:id=>params[:id]
    return
  end

  def add_colleges(colleges, job_id)
    AddedUniversity.delete_all("adder_id = '#{job_id}' and adder_type = 'JobPosition'")
    colleges.each{|c|
      unless c.blank?
        @uni = University.where(:institution => c).first
        if !@uni.nil?
          #if unni exists
          added_university = AddedUniversity.new(:adder_id => job_id, :adder_type => "JobPosition", :university_id => @uni.id)
          added_university.save
        else
          #if uni doesnt exist
          @new_uni = University.new(:institution => c, :activated=>false)
          if @new_uni.save
            added_university = AddedUniversity.new(:adder_id => job_id, :adder_type => "JobPosition", :university_id => @new_uni.id)
            added_university.save
          end
        end
      end
    }
  end

  def add_degree(degree, flag, job_id)
    AddedDegree.delete_all("adder_id = '#{job_id}' and adder_type = 'JobPosition'")
    if degree!=""
      degree_id = Degree.find_by_name(degree).id
          
      @added_degree = AddedDegree.new(
        :adder_id => job_id,
        :adder_type => "JobPosition",
        :required_flag => flag,#save STATUS
        :degree_id => degree_id)
      @added_degree.save
    end
    
  end
  
  def add_certificates(cert_names, job_id, required_certificate_flag)
    JobCriteriaCertificate.delete_all("job_id = '#{job_id}'")
    cert_names.each_with_index{|cert,i|
      unless cert.blank?
        @cert_obj  = NewCertificate.find_by_certification_name(cert.strip)
        @lic_obj = License.find_by_license_name(cert.strip)
        if !@cert_obj.nil?
          #save
          job_criteria_certificate = JobCriteriaCertificate.new(:job_id => job_id, :new_certificate_id => @cert_obj.id, :order=>i+1)
        elsif !@lic_obj.nil?
          job_criteria_certificate = JobCriteriaCertificate.new(:job_id => job_id, :license_id => @lic_obj.id, :order=>i+1)
        else
          #ActiveRecord::Base.connection.execute("INSERT INTO `new_certificates`(`Occupation`, `Sub-Occupation`, `certification_name`, `Certifying Organization`, `Certification Description`, `Source URL`, `activated`) VALUES(' ', ' ', '#{cert}', ' ', ' ', ' ', 0)")
          @c_obj = NewCertificate.create(:occupation=>"", :sub_occupation=>"", :certification_name=>cert, :certifying_organization=>"", :certification_description=>"", :source_url=>"", :activated=>false)
          #@c_obj = NewCertificate.where(:certification_name => cert).first
          job_criteria_certificate = JobCriteriaCertificate.new(:job_id => job_id, :new_certificate_id => @c_obj.id, :order=>i+1)
        end
        if !required_certificate_flag.blank? and required_certificate_flag[i] == "1"
          job_criteria_certificate.required_flag = true
        else
          job_criteria_certificate.required_flag = false
        end
        job_criteria_certificate.save
      end
    }
  end
    
  def employer_save_credentials
    reload_employer_session
    @job = Job.find(params[:id])

    #SAVE ROLES
    if !params[:selected_roles].blank?
      AddedRole.delete_all("adder_id = '#{@job.id}' AND adder_type = 'JobPosition'")
      role_1, role_2, role_3 = params[:selected_roles].split("_roles_array_")

      AddedRole.create(:adder_id => @job.id, :adder_type => "JobPosition", :code => role_1)
      if !role_2.nil?
        AddedRole.create(:adder_id => @job.id, :adder_type => "JobPosition", :code => role_2)
      end
      if !role_3.nil?
        AddedRole.create(:adder_id => @job.id, :adder_type => "JobPosition", :code => role_3)
      end
    end
    #language
    @required_languages_flag = params[:required_languages].blank? ? [] : params[:required_languages].split(",")
    @job.employer_add_languages(create_language_hash(params[:selected_languages]),@required_languages_flag)
    #certificate
    @cert_names = params[:certificate_param].blank? ? [] : params[:certificate_param].html_safe.split("_jucert_")
    required_certificate_flag = params[:required_certificates].blank? ? [] : params[:required_certificates].split(",")
    add_certificates(@cert_names,@job.id,required_certificate_flag)
    #college
    @colleges = params[:selected_colleges].blank? ? [] : params[:selected_colleges].html_safe.split("_ecolg_")
    add_colleges(@colleges, @job.id)
    #degree
    add_degree(params[:degree_param], params[:required_degree], @job.id)
    if params[:selected_languages].blank? || params[:selected_roles].blank?
      @job.credential_complete = false
    else
      @job.credential_complete = true
    end
    if session[:add_position]
      session[:add_position] = nil
    end
    generate_alerts_for_sub_ordinate("job-edit", @job)
    @job = check_if_job_is_complete(@job)
    @job.save(:validate => false)
    broadcast_job_feed
    if(!@job.id.nil? && @job.profile_complete == true && @job.active == true)
      @job.save(:validate => false)
      PairingLogic.delay.pairing_value_job(@job, "from_position_profile")
    end
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    if params[:position_parent_id].present?
      case params[:position_parent_id].to_i
      when -1
        ancestors = session[:employer].ancestor_ids
        subtree = session[:employer].subtree_ids
        @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      when 0
        ancestors = session[:employer].ancestor_ids
        descendants = session[:employer].descendant_ids
        @jobs = session[:employer].get_my_positions(ancestors, descendants)
      else
        sl_emp = Employer.find(params[:position_parent_id].to_i)
        ancestors = sl_emp.ancestor_ids
        subtree = sl_emp.subtree_ids
        @jobs = sl_emp.get_jobs_with_group(ancestors, subtree)
      end
    else
      @ancestors = session[:employer].ancestor_ids
      @subtree = session[:employer].subtree_ids
      @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)
    end
    render "open_next_incomplete_tab", :formats => [:js], :layout => false
    return    
  end
        
  def candidate_pool
    job=Job.find_by_id(params[:id], :conditions => "employer_id IN (#{session[:employer].subtree_ids.join(',')}) AND deleted=false")
    if(job.nil?)
      redirect_to :controller => "employer_account", :action => "index"
      return
    end
    if job.profile_complete == false
      redirect_to :controller => "position_profile", :action => "new_employer_profile", :id => job.id, :selected => params[:selected]
      return
    end
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.select("jobs.name, job_seekers.first_name, employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.id, employer_alerts.created_at AS created_at").joins("JOIN jobs ON employer_alerts.job_id = jobs.id JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("jobs.employer_id IN (?) AND employer_alerts.read = ? AND employer_alerts.new = ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id).group("employer_alerts.id").order("created_at desc").all.size
    params[:start] ||= 0
    params[:limit] ||= 10
    @start = params[:start]
    @limit = params[:limit]
    #@employer_category = Employer.where("employers.id=? and company_groups.deleted=?", session[:employer], false).joins("join companies on employers.company_id = companies.id join company_groups on companies.id = company_groups.company_id").all
    #@all_jobs = Job.where("employer_id=? and deleted=?" , session[:employer].id, false).all
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    #subtree size:
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    @sort = "pairing"
    @order = "desc"
    get_candidate_pool_data(@sort, @order, @start, @limit)
    @start = @start.to_i
    render :layout => "dashboard"    
  end

  #candidate pool data
  def get_candidate_pool
    @order = params[:order].to_s == "desc" ? "desc" : "asc"
    @sort = params[:sort] ||= "pairing"
    @acitivity = params[:activity]
    params[:scroll] ||= false
    
    params[:start] ||= 0
    params[:limit] ||= 10
      
    @start = params[:start]
    @limit = params[:limit]
    
    support_sort = ["name", "pairing", "first_name", "share_name", "status", "job_seekers.first_name", "vet"]
    @sort = support_sort.include?(@sort) ? @sort : "pairing"
    if params[:filter].to_s == "0"
      get_candidate_pool_data(@sort, @order, @start, @limit, @activity)
    elsif params[:filter].to_s == "1"
      get_candidate_pool_data_filter(@sort, @order, @start, @limit, @activity)
    end
    
    @start = @start.to_i
    if params[:from] == "table_data"
      render :partial => "/position_profile/employer_profile/pool_seeker_data", :layout => false
    else
      if params[:scroll]
        render :partial =>"/position_profile/employer_profile/pool_seeker_table_rows", :layout => false
      else
        render :partial =>"/position_profile/employer_profile/pool_seeker_table", :layout => false
      end
    end
    
    return
  end

  def view
    @show_preview_flag = show_preview_to_employer(@job)
    if @show_preview_flag
      @job_location = JobLocation.new
      if not @job.job_location_id.blank?
        @job_location = JobLocation.find(@job.job_location_id)
      end

      @address_str = form_address_str(@job_location)
      @desired_emp = @job.desired_employments.collect{|d| d.name}.join(", ")
      @language_skills = @job.language_skill_proficiency
      @job_certifications = @job.certification_required
    end
  end

  def redirect_if_employer_has_no_jobs
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?", false).all.size
    if all_jobs_size < 1
      redirect_to :controller=>"employer_account", :action=>"index"
    end
  end
  
  def xref
    unless params[:cover_job_id].nil?
      job = Job.find_by_id(params[:cover_job_id])
      unless job.nil?
        job_status = JobStatus.where(:job_id=>job.id,:job_seeker_id=>params[:cs_id].downcase.gsub("cs","").to_i).first
        unless job_status.nil?
          session[:cover_note_job_id] = job.id
          if params[:selected]
            redirect_to "/position_profile/xref/#{params[:cs_id]}?selected=#{params[:selected]}"
          else
            redirect_to :controller => "position_profile", :action => "xref", :cs_id => params[:cs_id]
          end
          return
        end
      end
    end
    unless session[:cover_note_job_id].nil?
      @job_status_cover_note = JobStatus.where(:job_id=>session[:cover_note_job_id],:job_seeker_id=>params[:cs_id].downcase.gsub("cs","").to_i).first
      @job_cover_note = Job.find_by_id(session[:cover_note_job_id])
    end
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.select("jobs.name, job_seekers.first_name, job_seekers.last_name,
    employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.id,
    employer_alerts.created_at AS created_at").joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id
    LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("(jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = #{session[:employer].id})
    AND employer_alerts.read = ? AND employer_alerts.new = ? AND employer_alerts.purpose <> ?
    AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.created_at desc").all.size
    @job_seeker = nil
    # @employer_category = Employer.find(:all, :conditions => ["employers.id=? and company_groups.deleted=?", session[:employer], false], :joins =>"join companies on employers.company_id = companies.id join company_groups on companies.id = company_groups.company_id")
    # @all_jobs = Job.find(:all, :conditions=>["employer_id=? and deleted=?" , session[:employer].id, false ])
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?", false).all.size
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    #subtree size:
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    @sort = "active desc,internal desc," #"jobs.active"
    @order = "pairing desc"
    params[:scroll] ||= false
    params[:start] ||= 0
    params[:limit] ||= 10
    @start = params[:start]
    @limit = params[:limit]
    @pos = -1
    xref_pool_data(@sort, @order, @start, @limit, @acitivity)
    @start = @start.to_i
    #get_xref(@sort, @order)
  end
  

  def get_xref(sort, order)
    order_by = "#{sort} #{order}"
    xref_pool_data(@sort, @order)
    
  end
  #cross reference data
  def get_xref_data
    @order = params[:order]
    @sort = params[:sort] || "pairing"
    @acitivity = params[:activity]
    
    params[:scroll] ||= false
    
    params[:start] ||= 0
    params[:limit] ||= 10
      
    @start = params[:start]
    @limit = params[:limit]
    
    #support_sort = ["name", "pairing", "first_name", "share_name","jobs.name","status","jobs.active"]
    #@sort = support_sort.include?(@sort) ? @sort : "pairing"
    @pos = params[:pos].to_i
    
    xref_pool_data(@sort, @order, @start, @limit, @acitivity, params[:pos].to_i)
    @start = @start.to_i
    if params[:scroll] 
      render :partial =>"/position_profile/xref_row_rows", :layout => false
    else
      render :partial =>"/position_profile/xref_row", :layout => false  
    end
    
    return
  end
  
  def seeker_profile
    @job_seeker = JobSeeker.find(params[:seeker_id])
    @job_seeker_birkman_detail = @job_seeker.job_seeker_birkman_detail

    if not params[:job_id].blank?
      @job = Job.find(params[:job_id])
    end
  end
    
  def delete_group
    reload_employer_session
    CompanyGroup.remove(session[:employer].company_id, params[:group_id])
    broadcast_job_feed
    @ancestors = session[:employer].ancestor_ids
    if params[:parent_id] != "0"
      @subtree = session[:employer].subtree_ids
      @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)
    else
      @descendants = session[:employer].descendant_ids
      @jobs = session[:employer].get_my_positions(@ancestors, @descendants)
    end
    
    @job_statuses = Job.get_job_status(@jobs,session[:employer].id)
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @current_employer= Employer.where("id=?", session[:employer].id).first
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    group = CompanyGroup.where(:id => params[:group_id]).first
    all_group_jobs = group.jobs
    all_group_jobs.each{|job|
      job_seeker_ids = JobStatus.select("job_seeker_id, employers.company_id as comp_id").joins("join jobs on jobs.id = job_statuses.job_id join employers on employers.id = jobs.employer_id").where("job_id = #{job.id} and (interested = 1 or wild_card = 1)")
      job_seeker_ids.each{|j|
        alert = JobSeekerNotification.create(:job_seeker_id => j.job_seeker_id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 13, :visibility => true, :company_id => j.comp_id)
        job_seeker = JobSeeker.where(:id => j.job_seeker_id).first
        if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
          Notifier.email_job_seeker_notifications(job_seeker, alert).deliver
          job_seeker.notification_email_time = DateTime.now
          job_seeker.save(:validate => false)
        end
      }
    }
    render 'delete_positions', :formats=>[:js], :layout=>false
    return
  end
    
  def delete_job
    reload_employer_session
    @job = Job.update_all({:deleted => true}, ['id =  ?', params[:job_id]])
    generate_alerts_for_sub_ordinate("job-delete", params[:job_id].to_i)
    broadcast_job_feed
    @job = Job.find_by_id(params[:job_id].to_i)
#    job_ids = Array.new
#    job_ids<<@job.id
    
#    if @job.active
#      if @job.internal
#        js_ids = JobSeeker.where(:company_id => @job.company_id, :activated => true).map{|js| js.id}
#        BroadcastController.new.delay(:priority => 6).opportunities_internal(@job.company_id, js_ids)
#        js_ids.each do |id|
#          BroadcastController.new.delay(:priority => 6).xref_update(id, @job.company_id, job_ids)
#        end
#      else
#        BroadcastController.new.delay(:priority => 6).opportunities_internal(@job.company_id, JobSeeker.where(:company_id => @job.company_id, :activated => true).map{|js| js.id})
#        BroadcastController.new.delay(:priority => 6).opportunities_normal(JobSeeker.where(:company_id => nil, :activated => true).map{|js| js.id})
#        js_ids = JobSeeker.where("company_id = #{@job.company_id} OR company_id IS NULL AND activated = #{true}").map{|js| js.id}
#        js_ids.each do |id|
#          BroadcastController.new.delay(:priority => 6).xref_update(id, @job.company_id, job_ids)
#        end
#      end
#    end
#
#    @job.employer.ancestor_ids.each do |id|
#      BroadcastController.new.delay(:priority => 6).employer_dashboard(id, -1)
#    end
#    BroadcastController.new.delay(:priority => 6).employer_dashboard(@job.employer.id, -1)


    #changes (checked)
    BroadcastController.new.employer_update(@job.company_id, "dashboard", [@job.id], [])
    BroadcastController.new.employer_update(@job.company_id, "xref", [@job.id], JobSeeker.where(:activated=>true).map{|m| m.id})
    if @job.active
      if @job.internal
        @job.company.path_ids.each do |c|
          BroadcastController.new.opportunities_internal(c, JobSeeker.where(:company_id => @job.company.path_ids, :activated => true).map{|js| js.id})
        end
      else
        @job.company.path_ids.each do |c|
          BroadcastController.new.opportunities_internal(c, JobSeeker.where(:company_id => @job.company.path_ids, :activated => true).map{|js| js.id})
        end
        BroadcastController.new.opportunities_normal(JobSeeker.where(:company_id=>nil, :activated => true).map{|js| js.id})
      end
    end
    #
    
    @ancestors = session[:employer].ancestor_ids
    if params[:parent_id] != "0"
      @subtree = session[:employer].subtree_ids
      @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)
    else
      @descendants = session[:employer].descendant_ids
      @jobs = session[:employer].get_my_positions(@ancestors, @descendants)
    end
    @job_statuses = Job.get_job_status(@jobs,session[:employer].id)
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @current_employer= Employer.where("id=?", session[:employer].id).first
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    job_seeker_ids = JobStatus.select("job_seeker_id, employers.company_id as comp_id").joins("join jobs on jobs.id = job_statuses.job_id join employers on employers.id = jobs.employer_id").where("job_id = #{params[:job_id]} and (interested = 1 or wild_card = 1)")
    job_seeker_ids.each{|j|
      alert = JobSeekerNotification.create(:job_seeker_id => j.job_seeker_id, :job_id => params[:job_id], :notification_type_id => 3, :notification_message_id => 13, :visibility => true, :company_id => j.comp_id)
      job_seeker = JobSeeker.where(:id => j.job_seeker_id).first
      if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
        Notifier.email_job_seeker_notifications(job_seeker, alert).deliver
        job_seeker.notification_email_time = DateTime.now
        job_seeker.save(:validate => false)
      end
    }
    render 'delete_positions', :formats=>[:js], :layout=>false
    return
  end
    
  def make_job_active
    Job.activate_by_employer(params[:id],session[:employer].id)
    render :text => "done"
  end

  def profile
    reload_employer_session
    @ancestors = session[:employer].ancestor_ids
    @subtree = session[:employer].subtree_ids
    @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)

    if params[:id].nil?
      session[:add_position] = true
      redirect_to :controller=>"position_profile", :action =>"new_employer_profile"
    else
      redirect_to "/position_profile/new_employer_profile/#{params[:id]}?selected=#{params[:selected]}"
    end
  end
  
  def overview
    if params[:jid].to_i != 0
      @job = Job.where("id = #{params[:jid]} AND employer_id IN (#{session[:employer].subtree_ids.join(",")}) AND deleted=false").first
      @company_group_id = @job.company_group_id
      @desired_emp = @job.desired_employments.collect{|d| d.name}.join(", ")
      @job_location = JobLocation.new
      if not @job.job_location_id.blank?
        @job_location = JobLocation.find(@job.job_location_id)
      end
      @address_str = form_address_str(@job_location)
    else
      @job=Job.new
      @company_group_id = params[:cat_id]
    end
    @employer = Employer.find(session[:employer].id)
    company_old = @employer.company
        
    if @job.company.nil?
      @company = session[:employer].company
    else
      @company = @job.company
    end
    @job_location = @job.job_location
        
    @selected_employment_ids  = @job.job_criteria_desired_employments.map{|j| j.desired_employment_id}
    @desired_employments = DesiredEmployment.find(:all)
        
    @ownerships = OwnerShipType.find(:all)
        
    @company_groups = session[:employer].get_groups
    @compensation_range = $compensation_values
    @paidtime_range = $desired_paid_time
    @commute_range = $desired_commute_radius

    @employer_added_roles = []
    @languages = Language.find(:all)
    @new_selected_certificates = ""
    @selected_languages = ""
    @selected_colleges = ""
    @selected_degree = ""
    @required_certificates_arr = ""
    @required_languages_arr = ""
    @degree_flag = ""
    
    if params[:jid].to_i != 0
      @language_skills = @job.language_skill_proficiency
      @job_certifications = @job.certification_required
      credentials
    end
    
    render :partial=>"/position_profile/position_overview", :locals=>{:commute_range=>@commute_range,:paidtime_range=>@paidtime_range,:compensation_range=>@compensation_range,
      :company_groups=>@company_groups,:ownerships=>@ownerships,:desired_employments=>@desired_employments,:selected_employment_ids=>@selected_employment_ids,:job_location=>@job_location,
      :company=>@company,:employer=>@employer,:job=>@job,:address_str=>@address_str,:desired_emp=>@desired_emp,:company_group_id=>@company_group_id}
  end
  
  def workenv
    if params[:jid].to_i != 0
      @job = Job.where("id = #{params[:jid]} AND employer_id IN (#{session[:employer].subtree_ids.join(",")}) AND deleted=false").first
      @work_questions = WorkenvQuestion.question_list
      @job_we_ques = JobWorkenvQuestion.where("job_id = ?",params[:jid]).order("id asc").all.map{|e| e.score}
      @role_questions = RoleQuestion.question_list
      @job_role_ques = JobRoleQuestion.where("job_id = ?",@job.id).order("id asc").all.map{|e| e.score}
      x_score,y_score = @job.work_env_score
      @emp_workenv_text, @emp_workenv_color = WorkenvQuestion.text_and_color_by_score(x_score,y_score)
      x_score_role,y_score_role= @job.role_score
      @emp_role_color_text, @emp_role_color_val = RoleQuestion.text_and_color_by_score(x_score_role,y_score_role)
      if @emp_workenv_text.blank? and @emp_workenv_color.blank? and @emp_role_color_text.blank? and @emp_role_color_val.blank?
        render :partial => "/position_profile/employer_profile/work_role_env_questions"
      elsif params[:modify].to_i == 1
        render "edit_workenv", :formats=>[:js], :layout=>false
      elsif @job.personality_work_complete == false and @job.personality_work_complete == false
        render :partial => "/position_profile/employer_profile/work_role_env_questions"
      else
        render :partial => "work_environment_and_role"
      end
      #more if else might be required here to differentiate between complete and incomplete forms
    else
      #new position initial state
      @job = Job.new
      @work_questions = WorkenvQuestion.question_list
      @job_we_ques = JobWorkenvQuestion.where("job_id = ?",@job.id).order("id asc").all.map{|e| e.score}
      @role_questions = RoleQuestion.question_list
      @job_role_ques = JobRoleQuestion.where("job_id = ?",@job.id).order("id asc").all.map{|e| e.score}
      render :partial => "/position_profile/employer_profile/work_role_env_questions", :locals => {:id => @job.id}
    end
  end
  
  def preview_tab
    if params[:jid].to_i != 0
      render :partial=>"/position_profile/preview_tab"
    end
  end
  
  def new_employer_profile
    reload_employer_session
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.select("jobs.name, job_seekers.first_name, employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id, employer_alerts.id, employer_alerts.created_at AS created_at").joins("JOIN jobs ON employer_alerts.job_id = jobs.id JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("jobs.employer_id IN (?) AND employer_alerts.read = ? AND employer_alerts.new = ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id).group("employer_alerts.id").order("created_at desc").all.size
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    @career_clusters = CareerCluster.select("DISTINCT career_cluster")

    if params[:id].to_i != 0
      @job = Job.where("id = #{params[:id]} AND employer_id IN (#{session[:employer].subtree_ids.join(",")}) AND deleted=false").first
      @company_group_id = @job.company_group_id
      if(@job.nil?)
        redirect_to :controller => "employer_account", :action => "index"
        return 
      end

      if @job.profile_complete == true
        if session[:add_position]
          session[:add_position] = nil
        end
      else
        session[:add_position] = true
      end
    else
      @job=Job.new
      @company_group_id = params[:cat_id]
    end
  end

  def create_new_emp_profile
    reload_employer_session
    if params[:jobid] == ""
      @job = Job.new()
    else
      @job = Job.find(params[:jobid])
    end

    if @job.company.nil?
      @company = session[:employer].company
    else
      @company = @job.company
    end

    @ownerships = OwnerShipType.find(:all)
    job_hash = {:name => params[:name], :armed_forces => params[:armed_forces], :summary => params[:summary],:company_id => @company.id,:company_group_id => params[:company_group_id],:hiring_company => params[:hiring_company],:hiring_company_name => params[:hiring_company_name],:website_one => params[:website_1],:website_title_one => params[:website_title_1],:website_two => params[:website_2],:website_title_two => params[:website_title_2],:website_three => params[:website_3],:website_title_three => params[:website_title_3] }

    @job.attributes = job_hash

    if @job.employer_id.nil?
      @job.employer_id = session[:employer].id
    end

    if @job.hiring_company == true
      @job.hiring_company_name = @job.company.name
    end

    if not params[:website_1].blank?
      @job.website_one = params[:website_1]
      @job.website_one = @job.website_one.split("//")
      if not (@job.website_one[0] == "http:" or @job.website_one[0] == "https:")
        @job.website_one = "http://"+params[:website_1]
      else
        @job.website_one = params[:website_1]
      end
    else
      @job.website_one = nil
    end
    if not params[:website_2].blank?
      @job.website_two = params[:website_2]
      @job.website_two = @job.website_two.split("//")
      if not (@job.website_two[0] == "http:" or @job.website_two[0] == "https:")
        @job.website_two = "http://"+params[:website_2]
      else
        @job.website_two = params[:website_2]
      end
    else
      @job.website_two = nil
    end
    if not params[:website_3].blank?
      @job.website_three = params[:website_3]
      @job.website_three = @job.website_three.split("//")
      if not (@job.website_three[0] == "http:" or @job.website_three[0] == "https:")
        @job.website_three = "http://"+params[:website_3]
      else
        @job.website_three = params[:website_3]
      end
    else
      @job.website_three = nil
    end
    if params[:remote_work] != "1"
      latitude = params[:company_latitude]
      longitude = params[:company_longitude]
      if params[:street_address_check].to_i == 1
        require 'geocoder'
        @result = Geocoder.search([params[:company_street_one], params[:company_city], params[:company_state], params[:company_country]].join(", "))
        unless @result.empty?
          unless @result.first.nil?
            latitude = @result.first.latitude
            longitude = @result.first.longitude
          end
        end
      end
      @job_location = JobLocation.new({:street_one => params[:company_street_one].delete(","),:street_two => params[:company_street_two],:city => params[:company_city],:state => params[:company_state],:country => params[:company_country],:zip_code => params[:company_zip],:latitude => latitude,:longitude => longitude})
      @job_location.save(:validate => false)
      @job.job_location_id = @job_location.id
    else
      @job.job_location_id = nil
    end
    
    @job.add_responsibilities(params[:responsiblities][0,5])
    @job.desired_commute_radius = params[:desired_commute_value]
    @job.desired_paid_offs = params[:desired_paidtime_value]
    @job.minimum_compensation_amount = params[:compensation_value_min]
    @job.maximum_compensation_amount = params[:compensation_value_max]
    if !params[:attachment_title].blank?
      params[:attachment_title].each_with_index do |attachment, j|
        @job.job_attachments[j].attachment_title = attachment # if !attachment.blank?
        @job.job_attachments[j].save!(:validate => false)
      end
    end
    add_remove_job_criteria_employment()
    @job.remote_work = params[:remote_work]
    @job.save!(:validate => false)
    
    # Roles
    if !params[:selected_roles].blank?
      AddedRole.delete_all("adder_id = '#{@job.id}' AND adder_type = 'JobPosition'")
      role_1, role_2, role_3 = params[:selected_roles].split("_roles_array_")
      AddedRole.create(:adder_id => @job.id, :adder_type => "JobPosition", :code => role_1)
      if !role_2.nil?
        AddedRole.create(:adder_id => @job.id, :adder_type => "JobPosition", :code => role_2)
      end
      if !role_3.nil?
        AddedRole.create(:adder_id => @job.id, :adder_type => "JobPosition", :code => role_3)
      end
    end
    # Language
    @required_languages_flag = params[:required_languages].blank? ? [] : params[:required_languages].split(",")
    @job.employer_add_languages(create_language_hash(params[:selected_languages]),@required_languages_flag)
    # Certificate
    @cert_names = params[:certificate_param].blank? ? [] : params[:certificate_param].html_safe.split("_jucert_")
    required_certificate_flag = params[:required_certificates].blank? ? [] : params[:required_certificates].split(",")
    add_certificates(@cert_names,@job.id,required_certificate_flag)
    # College
    @colleges = params[:selected_colleges].blank? ? [] : params[:selected_colleges].html_safe.split("_ecolg_")
    add_colleges(@colleges, @job.id)
    # Degree
    add_degree(params[:degree_param], params[:required_degree], @job.id)

    if params[:overview_complete].to_i == 1
      @job.basic_complete = true
    else
      @job.basic_complete = false
    end
    if params[:selected_languages].blank? || params[:selected_roles].blank?
      @job.credential_complete = false
    else
      @job.credential_complete = true
    end
    if session[:add_position]
      session[:add_position] = nil
    end
    generate_alerts_for_sub_ordinate("job-edit", @job)
    @job = check_if_job_is_complete(@job)
    @job.save!(:validate => false)
    broadcast_job_feed
    if(!@job.id.nil? && @job.profile_complete == true && @job.active == true)
      @job.save(:validate => false)
      PairingLogic.delay.pairing_value_job(@job, "from_position_profile")
    end

    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    if params[:position_parent_id].present?
      logger.info("***params[:position_parent_id]#{params[:position_parent_id]}")
      case params[:position_parent_id].to_i
      when -1
        ancestors = session[:employer].ancestor_ids
        subtree = session[:employer].subtree_ids
        @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      when 0
        ancestors = session[:employer].ancestor_ids
        descendants = session[:employer].descendant_ids
        @jobs = session[:employer].get_my_positions(ancestors, descendants)
      else
        sl_emp = Employer.find(params[:position_parent_id].to_i)
        ancestors = sl_emp.ancestor_ids
        subtree = sl_emp.subtree_ids
        @jobs = sl_emp.get_jobs_with_group(ancestors, subtree)
      end
    else
      @ancestors = session[:employer].ancestor_ids
      @subtree = session[:employer].subtree_ids
      @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)
    end

    render "position_preview_save", :formats=>[:js], :layout=>false
    # render "open_next_incomplete_tab", :formats => [:js], :layout => false
  end

  def upload_attachment
    flag = 0
    @create = 0
    if params[:job][:id].to_i!=0
      @job=Job.find(params[:job][:id])
      @job_attachment = @job.job_attachments.new
      @job_attachment.attributes = params[:job_attachment]
      if @job_attachment.attachment_file_size <= 5242880 and (@job_attachment.attachment_content_type.split('/')[1] == "pdf" || @job_attachment.attachment_content_type.split('/')[1] == "msword" || @job_attachment.attachment_content_type.split('/')[1] == "vnd.openxmlformats-officedocument.wordprocessingml.document")
        @job_attachment.save!(:validate => false)
        flag = 1
        @create = 0
      end
    else
      @job=Job.new()
      @job.attributes = params[:job]
      @job_attachment = @job.job_attachments.new
      @job_attachment.attributes = params[:job_attachment]
      @job.employer_id = session[:employer].id
      if @job_attachment.attachment_file_size <= 5242880 and (@job_attachment.attachment_content_type.split('/')[1] == "pdf" || @job_attachment.attachment_content_type.split('/')[1] == "msword" || @job_attachment.attachment_content_type.split('/')[1] == "vnd.openxmlformats-officedocument.wordprocessingml.document")
        @job.save!(:validate => false)
        @job_attachment.save!(:validate => false)
        flag = 1
        @create = 1
      end
    end

    if flag == 1
      #upload successful
      responds_to_parent do
        render 'upload_success', :formats=>[:js], :layout=>false
      end
    else
      responds_to_parent do
        render 'upload_failure', :formats=>[:js], :layout=>false
      end
    end
  end

  def delete_attachment
    @job_attachment = JobAttachment.includes(:job).find(params[:id])
    @job = @job_attachment.job
    File.delete(@job_attachment.attachment.path)
    # FileUtils.remove_dir(File.expand_path(File.dirname(@job_attachment.attachment.path)), force = true)
    @job_attachment.destroy

    render :partial=>"/position_profile/attachment", :locals=>{:job=>@job}
    return
  end
  
  def show_ie_popup
    if params[:id].to_i != 0 
      @job = Job.where(:id=>params[:id]).first
    else
      @job = Job.new
    end
    render 'show_ie_popup', :formats=>[:js], :layout=>false
    #    render :update do |page|
    #      page.replace_html "file_upload_ie", :partial=>"/position_profile/show_ie_popup", :locals=>{:job=>@job}
    #    end
    return
  end

  def save_work_and_role_env_questions
    @job = Job.find(params[:job_id])
    
    @tab2_workenv_work = params[:tab2_workenv_work].to_i
    @tab2_workenv_role = params[:tab2_workenv_role].to_i
    @tab2_workenv_work == 0 ? "#{@job.personality_work_complete = false}" : "#{@job.personality_work_complete = true if @tab2_workenv_work == 1}"
    @tab2_workenv_role == 0 ? "#{@job.personality_role_complete = false}" : "#{@job.personality_role_complete = true if @tab2_workenv_role == 1}"
    @modified = 1
    generate_alerts_for_sub_ordinate("job-edit", @job)
    @job = check_if_job_is_complete(@job)
    @job.save(:validate => false)
    new_save_work_questions(@job)
    new_save_role_questions(@job)
    if(!@job.id.nil? && @job.profile_complete == true && @job.active == true)
      @job.save(:validate => false)
      PairingLogic.delay.pairing_value_job(@job, "from_position_profile")
    end

    if @job.personality_work_complete == true and @job.personality_role_complete == true
      #Hide current set of questions
      #Show Modify option section
      x_score,y_score = @job.work_env_score
      @emp_workenv_text, @emp_workenv_color = WorkenvQuestion.text_and_color_by_score(x_score,y_score)
      x_score_role,y_score_role= @job.role_score
      @emp_role_color_text, @emp_role_color_val = RoleQuestion.text_and_color_by_score(x_score_role,y_score_role)
      render "work_and_role_complete", :formats => [:js], :layout => false
    else
      render 'validate_workenv_role', :formats => [:js], :layout => false
    end
    return
  end

  def new_save_work_questions(job)
    slider_values_arr_work= params[:slider_values_work].split(",")
    work_questions = WorkenvQuestion.question_list 
    JobWorkenvQuestion.delete_all("job_id = '#{job.id}'")
       
    work_questions.each_with_index{|wq,index|
      JobWorkenvQuestion.create({:workenv_question_id => wq.id,:score=>slider_values_arr_work[index],:job_id=>job.id})
    }
    job.save_work_env_score
  end

  def new_save_role_questions(job)
    slider_values_arr_role = params[:slider_values_role].split(",")
    role_questions = RoleQuestion.question_list
    JobRoleQuestion.delete_all("job_id = '#{job.id}'")
      
    role_questions.each_with_index{|rq,index|
      JobRoleQuestion.create({:role_question_id => rq.id,:score=>slider_values_arr_role[index],:job_id=>job.id})
    }
    job.save_role_env_score
  end

  def xref_check
    #params[:xref_val].downcase.gsub("cs","")
    @job_seeker = JobSeeker.where("id = #{params[:xref_val].downcase.gsub("cs","")} and ((company_id IN (#{session[:employer].company.path_ids.join(',')}) and ics_type_id IN (1,2,3)) or (company_id is null and ics_type_id = 4))").first
    render 'xref_check', :formats=>[:js], :layout=>false
  end

  private

  def show_preview_to_employer(job)
    return (job.basic_complete and job.personality_work_complete and job.personality_role_complete and job.credential_complete) ? true : false
  end

  def get_candidate_pool_data(sort, order, start, limit, activity=nil)
    select_str = "job_seekers.id, if(job_seekers.company_id IS NULL, 0, 1) as internal, job_seekers.first_name, job_seekers.armed_forces, job_seekers.zip_code, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, job_statuses.read_on, jobs.code as job_code, jobs.armed_forces as vet, share_platforms.name as share_name, pairing_logics.pairing_value as pairing "
    order_new = ""
    if sort == "status"
      order_new = "job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    elsif sort == "vet"
      order_new = "job_seekers.armed_forces #{order}, vet #{order}"
    else
      order_new = "#{sort} #{order}"
    end
    if !@job.blank?
      if !params[:activity].blank? or !activity.blank?
        activity_candidate_pool(select_str, sort, order, start, limit)
      else
        if @job.internal == true
          @job_seekers = JobSeeker.select(select_str)
          .joins("left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and (job_statuses.job_id =#{@job.id} or job_statuses.job_id is null)
                     join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id
                     left join jobs on pairing_logics.job_id = jobs.id
                     left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null)
                     left join share_platforms on log_job_shares.share_platform_id = share_platforms.id")
          .where("(jobs.id =#{@job.id} or jobs.id is null)  and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null) and (jobs.deleted = 0 or jobs.deleted is null) and pairing_logics.job_id = ? and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id)
          .group("pairing_logics.job_seeker_id")
          .order(order_new)
          .limit("#{start},#{limit}").all
        else
          @job_seekers = JobSeeker.select(select_str)
          .joins("left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and (job_statuses.job_id =#{@job.id} or job_statuses.job_id is null)
                     join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id
                     left join jobs on pairing_logics.job_id = jobs.id
                     left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null)
                     left join share_platforms on log_job_shares.share_platform_id = share_platforms.id")
          .where("(jobs.id =#{@job.id} or jobs.id is null)  and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null) and (jobs.deleted = 0 or jobs.deleted is null) and pairing_logics.job_id = ? and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id)
          .group("pairing_logics.job_seeker_id")
          .order(order_new)
          .limit("#{start},#{limit}").all
        end
      end
    end
  end

  def get_candidate_pool_data_filter(sort, order, start, limit, activity=nil)
    reload_employer_session
    select_str = "job_seekers.id, if(job_seekers.company_id IS NULL, 0, 1) as internal, job_seekers.first_name, job_seekers.armed_forces, job_seekers.zip_code, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, job_statuses.read_on, jobs.code as job_code, jobs.armed_forces as vet, share_platforms.name as share_name, pairing_logics.pairing_value as pairing "
    order_new = ""
    if sort == "status"
      order_new = "job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    elsif sort == "vet"
      order_new = "job_seekers.armed_forces #{order}, vet #{order}"
    else
      order_new = "#{sort} #{order}"
    end
    if !@job.nil?
      if !params[:activity].blank? or !activity.blank?
        activity_candidate_pool_filter(select_str, sort, order, start, limit)
      else
        if session[:employer].account_type_id != 3
          condition = session[:employer].root.subtree_ids.join(',')
        else
          condition = session[:employer].id
        end
        if @job.internal == true
          @job_seekers = JobSeeker.select(select_str)
          .joins("left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and (job_statuses.job_id =#{@job.id} or job_statuses.job_id is null)
                       join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id
                       left join jobs on pairing_logics.job_id = jobs.id
                       left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null)
                       left join share_platforms on log_job_shares.share_platform_id = share_platforms.id")
          .where("(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{condition})) ) and (jobs.id =#{@job.id} or jobs.id is null)  and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null) and (jobs.deleted = 0 or jobs.deleted is null) and pairing_logics.job_id = ? and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id)
          .group("pairing_logics.job_seeker_id")
          .order(order_new)
          .limit("#{start},#{limit}").all
        else
          @job_seekers = JobSeeker.select(select_str)
          .joins("left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and (job_statuses.job_id =#{@job.id} or job_statuses.job_id is null)
                       join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id
                       left join jobs on pairing_logics.job_id = jobs.id
                       left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null)
                       left join share_platforms on log_job_shares.share_platform_id = share_platforms.id")
          .where("(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{condition})) ) and (jobs.id =#{@job.id} or jobs.id is null)  and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null) and (jobs.deleted = 0 or jobs.deleted is null) and pairing_logics.job_id = ? and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id)
          .group("pairing_logics.job_seeker_id")
          .order(order_new)
          .limit("#{start},#{limit}").all
        end
      end
    end
  end

  def xref_pool_data(sort, order, start, limit, activity=nil, selected = -1)
    reload_employer_session
    order_new = ""
    if sort == "status"
      order_new = "jobs.active #{order}, jobs.internal #{order},job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    elsif sort == "jobs.active"
      order_new = "jobs.active #{order}, jobs.internal #{order}"
    else
      order_new = "#{sort} #{order}"
    end
    if not params[:cs_id].blank?
      @job_seeker = JobSeeker.find(:first, :conditions =>["id = ?", params[:cs_id].downcase.gsub("cs","").to_i])
    end
    if session[:selected].nil?
      selected = selected
    else
      if params[:activity].present?
        selected = session[:selected]
      else
        selected = selected
      end
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
    
    if not @job_seeker.nil?
      if !params[:activity].blank? or !activity.blank?
        activity_xref_candidate_pool(sort, order, start, limit, selected)
      else
        if session[:employer].company.path_ids.include?(@job_seeker.company_id) and [1,2,3].include? @job_seeker.ics_type_id
          @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name,jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing",
            :conditions=>["jobs.deleted = ? and (job_statuses.job_seeker_id = #{@job_seeker.id} or job_statuses.job_seeker_id is null) and jobs.employer_id IN (#{condition}) and (log_job_shares.job_seeker_id = #{@job_seeker.id} or log_job_shares.job_seeker_id is null)", false],
            :joins=>"left join job_statuses on jobs.id = job_statuses.job_id and (job_statuses.job_seeker_id = #{@job_seeker.id} or job_statuses.job_seeker_id is null)
                   left join log_job_shares on log_job_shares.job_id = jobs.id and (log_job_shares.job_seeker_id= #{@job_seeker.id} or log_job_shares.job_seeker_id is null)
                   left join share_platforms on log_job_shares.share_platform_id = share_platforms.id
                   join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}",
            :order => order_new, :limit => "#{start},#{limit}")
        elsif @job_seeker.ics_type_id == 4 and @job_seeker.company_id.nil?
          @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name,jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing",
            :conditions=>["jobs.deleted = ? and ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and (job_statuses.job_seeker_id = #{@job_seeker.id} or job_statuses.job_seeker_id is null) and jobs.employer_id IN (#{condition}) and (log_job_shares.job_seeker_id = #{@job_seeker.id} or log_job_shares.job_seeker_id is null)", false],
            :joins=>"left join job_statuses on jobs.id = job_statuses.job_id and (job_statuses.job_seeker_id = #{@job_seeker.id} or job_statuses.job_seeker_id is null)
                   left join log_job_shares on log_job_shares.job_id = jobs.id and (log_job_shares.job_seeker_id= #{@job_seeker.id} or log_job_shares.job_seeker_id is null)
                   left join share_platforms on log_job_shares.share_platform_id = share_platforms.id
                   join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}",
            :order => order_new, :limit => "#{start},#{limit}")
        end
      end
    end
  end

  def activity_candidate_pool(select_str, sort, order, start, limit)
    reload_employer_session
    order_new = ""
    if sort == "status"
      order_new = "job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    else
      order_new = "#{sort} #{order}"
    end

    if session[:employer].account_type_id != 3
      condition = session[:employer].root.subtree_ids.join(',')
    else
      condition = session[:employer].id
    end
    case params[:activity]
    when "position_preview"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})  and job_statuses.read = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})  and job_statuses.read = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      end
    when "position_detail"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.considering = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.considering = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      end
    when "interested"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.interested = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.interested = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      end
    when "wild_card"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.wild_card = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.wild_card = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      end
    when "purchased_profile"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str,
          :joins => "join purchased_profiles on purchased_profiles.job_seeker_id = job_seekers.id and purchased_profiles.job_id = #{@job.id}
                   left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and (job_statuses.job_id = #{@job.id})
                   left join jobs on jobs.id = #{@job.id}
                   left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null)
                   left join share_platforms on log_job_shares.share_platform_id = share_platforms.id
                   join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id",
          :conditions =>["((jobs.id = #{@job.id} or jobs.id is null)
                   and (jobs.employer_id IN (#{condition}) or jobs.employer_id is null)
                   and (jobs.deleted = 0 or jobs.deleted is null)
                   and purchased_profiles.job_id = #{@job.id}
                   and pairing_logics.job_id = #{@job.id}
                   and purchased_profiles.payment_id != 0
                   and (log_job_shares.job_id = #{@job.id} or log_job_shares.job_id is null)) and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})"], :group=> "pairing_logics.job_seeker_id", :order=> order_new,:limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str,
          :joins => "join purchased_profiles on purchased_profiles.job_seeker_id = job_seekers.id and purchased_profiles.job_id = #{@job.id}
                   left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and (job_statuses.job_id = #{@job.id})
                   left join jobs on jobs.id = #{@job.id}
                   left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null)
                   left join share_platforms on log_job_shares.share_platform_id = share_platforms.id
                   join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id",
          :conditions =>["((jobs.id = #{@job.id} or jobs.id is null)
                   and (jobs.employer_id IN (#{condition}) or jobs.employer_id is null)
                   and (jobs.deleted = 0 or jobs.deleted is null)
                   and purchased_profiles.job_id = #{@job.id}
                   and pairing_logics.job_id = #{@job.id}
                   and purchased_profiles.payment_id != 0
                   and (log_job_shares.job_id = #{@job.id} or log_job_shares.job_id is null)) and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)"], :group=> "pairing_logics.job_seeker_id", :order=> order_new,:limit => "#{start},#{limit}")
      end
    end
  end

  def activity_candidate_pool_filter(select_str, sort, order, start, limit)
    reload_employer_session
    order_new = ""
    if sort == "status"
      order_new = "job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    else
      order_new = "#{sort} #{order}"
    end

    if session[:employer].account_type_id != 3
      condition = session[:employer].root.subtree_ids.join(',')
    else
      condition = session[:employer].id
    end
    case params[:activity]
    when "position_preview"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})) ) and job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.read = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})) ) and job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.read = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      end
    when "position_detail"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})) ) and job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.considering = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})) ) and job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.considering = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      end
    when "interested"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})) ) and job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.interested = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})) ) and job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.interested = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      end
    when "wild_card"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})) ) and job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.wild_card = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str, :joins => "join job_statuses on job_seekers.id = job_statuses.job_seeker_id join jobs on job_statuses.job_id = jobs.id join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id", :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')})) ) and job_statuses.job_id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and job_statuses.wild_card = ?  and pairing_logics.job_id=? and jobs.deleted = 0 and log_job_shares.job_id =#{@job.id} and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)", @job.id, true, @job.id], :group=> "pairing_logics.job_seeker_id", :order=> order_new, :limit => "#{start},#{limit}")
      end
    when "purchased_profile"
      if @job.internal == true
        @job_seekers = JobSeeker.find(:all, :select => select_str,
          :joins => "join purchased_profiles on purchased_profiles.job_seeker_id = job_seekers.id and purchased_profiles.job_id = #{@job.id}
                   left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and (job_statuses.job_id = #{@job.id})
                   left join jobs on jobs.id = #{@job.id}
                   left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null)
                   left join share_platforms on log_job_shares.share_platform_id = share_platforms.id
                   join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id",
          :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{condition})) )
                   and ((jobs.id = #{@job.id} or jobs.id is null)
                   and (jobs.employer_id IN (#{condition}) or jobs.employer_id is null)
                   and (jobs.deleted = 0 or jobs.deleted is null)
                   and purchased_profiles.job_id = #{@job.id}
                   and pairing_logics.job_id = #{@job.id}
                   and purchased_profiles.payment_id != 0
                   and (log_job_shares.job_id = #{@job.id} or log_job_shares.job_id is null)) and job_seekers.ics_type_id IN (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})"], :group=> "pairing_logics.job_seeker_id", :order=> order_new,:limit => "#{start},#{limit}")
      else
        @job_seekers = JobSeeker.find(:all, :select => select_str,
          :joins => "join purchased_profiles on purchased_profiles.job_seeker_id = job_seekers.id and purchased_profiles.job_id = #{@job.id}
                   left join job_statuses on job_seekers.id = job_statuses.job_seeker_id and (job_statuses.job_id = #{@job.id})
                   left join jobs on jobs.id = #{@job.id}
                   left join log_job_shares on job_seekers.id = log_job_shares.job_seeker_id and (log_job_shares.job_id=#{@job.id} or log_job_shares.job_id is null)
                   left join share_platforms on log_job_shares.share_platform_id = share_platforms.id
                   join pairing_logics on job_seekers.id = pairing_logics.job_seeker_id",
          :conditions =>["(job_seekers.track_shared_company_id = #{session[:employer].company_id} or (job_seekers.ics_type_id in (1,2,3) and job_seekers.company_id IN (#{@job.company.path_ids.join(',')})) or job_seekers.track_shared_job_id in (select jobs.id from jobs where jobs.employer_id IN (#{condition})) )
                   and ((jobs.id = #{@job.id} or jobs.id is null)
                   and (jobs.employer_id IN (#{condition}) or jobs.employer_id is null)
                   and (jobs.deleted = 0 or jobs.deleted is null)
                   and purchased_profiles.job_id = #{@job.id}
                   and pairing_logics.job_id = #{@job.id}
                   and purchased_profiles.payment_id != 0
                   and (log_job_shares.job_id = #{@job.id} or log_job_shares.job_id is null)) and (job_seekers.company_id IN (#{@job.company.path_ids.join(',')}) OR job_seekers.company_id IS NULL)"], :group=> "pairing_logics.job_seeker_id", :order=> order_new,:limit => "#{start},#{limit}")
      end
    end
  end

  def activity_xref_candidate_pool(sort, order, start, limit, selected = -1)
    reload_employer_session
    order_new = ""
    if sort == "status"
      order_new = "jobs.active #{order}, jobs.internal #{order},job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    elsif sort == "jobs.active"
      order_new = "jobs.active #{order}, jobs.internal #{order}"
    else
      order_new = "#{sort} #{order}"
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
    if session[:employer].company.path_ids.include? (@job_seeker.company_id) and [1,2,3].include? @job_seeker.ics_type_id
      case params[:activity]
      when "position_preview"
        @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name, jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing", :conditions=>["jobs.deleted = ? and job_statuses.job_seeker_id = ? and job_statuses.read = ? and jobs.employer_id IN (#{condition}) and log_job_shares.job_seeker_id = #{@job_seeker.id}", false, @job_seeker.id, true],:joins=>"join job_statuses on jobs.id = job_statuses.job_id join log_job_shares on log_job_shares.job_id = jobs.id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}", :group => "log_job_shares.job_id", :order => order_new, :limit => "#{start},#{limit}")
      when "position_detail"
        @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name, jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing", :conditions=>["jobs.deleted = ? and job_statuses.job_seeker_id = ? and job_statuses.considering = ? and jobs.employer_id IN (#{condition}) and log_job_shares.job_seeker_id = #{@job_seeker.id}", false, @job_seeker.id, true],:joins=>"join job_statuses on jobs.id = job_statuses.job_id join log_job_shares on log_job_shares.job_id = jobs.id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}", :group => "log_job_shares.job_id", :order => order_new, :limit => "#{start},#{limit}")
      when "interested"
        @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name, jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing", :conditions=>["jobs.deleted = ? and job_statuses.job_seeker_id = ? and job_statuses.interested = ? and jobs.employer_id IN (#{condition}) and log_job_shares.job_seeker_id = #{@job_seeker.id}", false, @job_seeker.id, true],:joins=>"join job_statuses on jobs.id = job_statuses.job_id join log_job_shares on log_job_shares.job_id = jobs.id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}", :group => "log_job_shares.job_id", :order => order_new, :limit => "#{start},#{limit}")
      when "wild_card"
        @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name, jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing", :conditions=>["jobs.deleted = ? and job_statuses.job_seeker_id = ? and job_statuses.wild_card = ? and jobs.employer_id IN (#{condition}) and log_job_shares.job_seeker_id = #{@job_seeker.id}", false,@job_seeker.id, true],:joins=>"join job_statuses on jobs.id = job_statuses.job_id join log_job_shares on log_job_shares.job_id = jobs.id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}", :group => "log_job_shares.job_id", :order => order_new, :limit => "#{start},#{limit}")
      end
    elsif @job_seeker.ics_type_id == 4 and @job_seeker.company_id.nil?
      case params[:activity]
      when "position_preview"
        @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name, jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing", :conditions=>["jobs.deleted = ? and ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and job_statuses.job_seeker_id = ? and job_statuses.read = ? and jobs.employer_id IN (#{condition}) and log_job_shares.job_seeker_id = #{@job_seeker.id}", false, @job_seeker.id, true],:joins=>"join job_statuses on jobs.id = job_statuses.job_id join log_job_shares on log_job_shares.job_id = jobs.id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}", :group => "log_job_shares.job_id", :order => order_new, :limit => "#{start},#{limit}")
      when "position_detail"
        @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name, jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing", :conditions=>["jobs.deleted = ? and ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and job_statuses.job_seeker_id = ? and job_statuses.considering = ? and jobs.employer_id IN (#{condition}) and log_job_shares.job_seeker_id = #{@job_seeker.id}", false, @job_seeker.id, true],:joins=>"join job_statuses on jobs.id = job_statuses.job_id join log_job_shares on log_job_shares.job_id = jobs.id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}", :group => "log_job_shares.job_id", :order => order_new, :limit => "#{start},#{limit}")
      when "interested"
        @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name, jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing", :conditions=>["jobs.deleted = ? and ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and job_statuses.job_seeker_id = ? and job_statuses.interested = ? and jobs.employer_id IN (#{condition}) and log_job_shares.job_seeker_id = #{@job_seeker.id}", false, @job_seeker.id, true],:joins=>"join job_statuses on jobs.id = job_statuses.job_id join log_job_shares on log_job_shares.job_id = jobs.id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}", :group => "log_job_shares.job_id", :order => order_new, :limit => "#{start},#{limit}")
      when "wild_card"
        @all_jobs_job_seeker = Job.find(:all,:select=>"jobs.id, jobs.armed_forces as vet, jobs.name, jobs.active, jobs.internal,jobs.expire_at, job_statuses.read, job_statuses.considering, job_statuses.interested, job_statuses.wild_card, job_statuses.read_on, job_statuses.considered_on, job_statuses.interested_on, job_statuses.wildcard_on, share_platforms.name as share_name, pairing_logics.pairing_value as pairing", :conditions=>["jobs.deleted = ? and ((jobs.active = #{true} and jobs.internal = #{false}) OR jobs.active = #{false}) and job_statuses.job_seeker_id = ? and job_statuses.wild_card = ? and jobs.employer_id IN (#{condition}) and log_job_shares.job_seeker_id = #{@job_seeker.id}", false,@job_seeker.id, true],:joins=>"join job_statuses on jobs.id = job_statuses.job_id join log_job_shares on log_job_shares.job_id = jobs.id join share_platforms on log_job_shares.share_platform_id = share_platforms.id join pairing_logics on jobs.id = pairing_logics.job_id and pairing_logics.job_seeker_id = #{@job_seeker.id}", :group => "log_job_shares.job_id", :order => order_new, :limit => "#{start},#{limit}")
      end
    end
    
  end

  def add_remove_job_criteria_employment
    JobCriteriaDesiredEmployment.delete_all("job_id = '#{@job.id}'")
    if not params[:desired_employment_ids].blank?
      for val in params[:desired_employment_ids].split(",")
        begin
          DesiredEmployment.find(val)
          @job.job_criteria_desired_employments << JobCriteriaDesiredEmployment.new({:desired_employment_id =>val})
        rescue ActiveRecord::RecordNotFound
        end
      end
    end
  end

  def set_session_selected_xref
    if session[:selected].nil?
      if params[:selected].nil?
        session[:selected] = -1
      else
        session[:selected] = params[:selected]
      end
    end
  end

  def get_left_panel_jobs
    reload_employer_session
    if session[:employer].account_type_id != 3
      if session[:selected].nil?
        @ancestors = session[:employer].ancestor_ids
        @subtree = session[:employer].subtree_ids
        @jobs = session[:employer].get_jobs_with_group(@ancestors, @subtree)
      else
        case session[:selected].to_i
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
            emp = Employer.find(session[:selected].to_i)
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
      end
    else
      ancestors = session[:employer].ancestor_ids
      descendants = session[:employer].descendant_ids
      @jobs = session[:employer].get_my_positions(ancestors, descendants)
    end
  end

  def get_left_panel_jobs_candidate_pool
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
  end

  def filter_basic_step
    if @job.id.blank?
      redirect_to :controller => :position_profile,:action=>:new
      return false
    end
  end

  def filter_workenv_step
    if @job.basic_complete == false
      redirect_to :controller => :position_profile,:action=>:edit,:id => @job.id
      return false
    end
  end

  def filter_role_step
    if @job.personality_work_complete == false
      redirect_to :controller => :position_profile,:action=>:edit,:id => @job.id
      return false
    end
  end

  def filter_credential_step
    if @job.personality_role_complete == false
      redirect_to :controller => :position_profile,:action=>:edit,:id => @job.id
      return false
    end
  end

  def determine_layout
    case action_name
    when "seeker_profile","delete_group"
      return false

    else
      return "dashboard"
    end
  end

  def validate_xref_request
    if params[:cs_id].present?
      begin
        js = JobSeeker.find(params[:cs_id].downcase.gsub("cs","").to_i)
      rescue
        redirect_to :controller => "employer_account", :action => "index"
      end
    end
  end

  def validate_request
    if params[:id].present?
      id = params[:id]
      begin
        job_exist = Job.find(id)
      rescue

      end
      redirect_to :controller => "employer_account", :action => "index" if (!job_exist.nil? && job_exist.deleted)
    elsif params[:cat_id].blank?
      redirect_to :controller => "employer_account", :action => "index"
    end
  end

  def check_if_job_is_complete(job)
    if job.basic_complete == true and job.personality_work_complete == true and job.personality_role_complete == true and job.credential_complete == true and job.overview_complete == true and job.detail_preview == true
      job.profile_complete = true
    else
      job.profile_complete = false
      job.active = false
      job.overview_complete = false
      job.detail_preview = false
    end
    return job
  end

  def generate_alerts_for_sub_ordinate(action, job)
    if action == "job-edit"
      if job.employer_id != session[:employer].id
        EmployerAlert.create!(:job_id => job.id, :purpose => action, :read => false, :employer_id => job.employer_id, :employer_job_activity => session[:employer].id)
      end
    elsif action == "job-delete"
      j = Job.find_by_id(job)
      if j.employer_id != session[:employer].id
        EmployerAlert.create!(:job_id => j.id, :purpose => action, :read => false, :employer_id => j.employer_id, :employer_job_activity => session[:employer].id)
      end
    end
  end

  def fetch_all_roles_for_logged_in_employer(job_id)
    @employer_added_roles = AddedRole.where("adder_id = ? AND adder_type = ?", job_id, "JobPosition")
    if !@employer_added_roles[0].nil?
      @career_cluster_role1 = CareerCluster.where("code = ?", @employer_added_roles[0].code).first
    end
    if !@employer_added_roles[1].nil?
      @career_cluster_role2 = CareerCluster.where("code = ?", @employer_added_roles[1].code).first
    end
    if !@employer_added_roles[2].nil?
      @career_cluster_role3 = CareerCluster.where("code = ?", @employer_added_roles[2].code).first
    end
  end
end