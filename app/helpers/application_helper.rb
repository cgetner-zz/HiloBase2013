# coding: UTF-8

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def are_you_sure_link(controller)
    if controller.controller_name == 'position_profile'
      if controller.action_name=='new_employer_profile' or controller.action_name=='create_new_emp_profile' or controller.action_name=='add_group'
        return true
      end
    end
    if controller.controller_name == 'ajax'
      if controller.action_name=='fetch_my_positions'
        return true
      end
    end
    return false
  end

  def employer_alert_msg(alert)
    case alert.purpose
    when "wild_card"
      return "POSITION: A candidate #{alert.first_name} #{alert.last_name} has Wildcarded your #{alert.name} position. Click here to see more."
    when "interested"
      return "POSITION: #{alert.first_name} #{alert.last_name} has applied for your #{alert.name} position. Click here to see more."
    when "legacy"
      return "CREDENTIALS: Update the information in the redesigned CREDENTIALS section of your positions and re-post them."
    when "best-fit"
      return "POSITION: A new best fit candidate #{alert.first_name} #{alert.last_name} for #{alert.name} has been identified. Click here to see more."
    when "better-fit"
      return "POSITION: A new better fit candidate #{alert.first_name} #{alert.last_name} for #{alert.name} has been identified. Click here to see more."
    when "good-fit"
      return "POSITION: A new good fit candidate #{alert.first_name} #{alert.last_name} for #{alert.name} has been identified. Click here to see more."
    when "expiry"
      return "POSITION: Your currently active position #{alert.name} is about to expire. Click here to review the position status."
    when "sub-deleted"
      return "ACCOUNT: #{fetch_employer_name(alert)} has deleted his/her account."
    when "ics-deleted"
      return "CANDIDATE: Internal Candidate #{fetch_job_seeker_name(alert)} has deleted his/her account."
    when "cs-purchased-deleted"
      return "CANDIDATE: Career Seeker #{fetch_job_seeker_name(alert)} whose profile you had purchased has deleted his/her account."
    when "job-active"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "POSITION: #{alert.name} has been activated by #{emp.first_name} #{emp.last_name}. Click here to see more."
    when "job-inactive"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "POSITION: #{alert.name} has been de-activated by #{emp.first_name} #{emp.last_name}. Click here to see more."
    when "job-edit"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "POSITION: #{alert.name} has been edited by #{emp.first_name} #{emp.last_name}. Click here to see more."
    when "job-delete"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "POSITION: #{alert.name} has been deleted by #{emp.first_name} #{emp.last_name}."
    when "job-re-assign"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "POSITION: #{alert.name} has been assigned to #{fetch_job_employers_name(alert)} by #{emp.first_name} #{emp.last_name}."
    when "folder-reassign"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      cg = CompanyGroup.select("employer_id, name").where("id = ?", alert.company_group_id).first
      new_emp = Employer.select("first_name, last_name").where("id = ?", cg.employer_id).first
      return "FOLDER: #{cg.name} has been assigned to #{new_emp.first_name} #{new_emp.last_name} by #{emp.first_name} #{emp.last_name}."
    when "folder-create"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      cg = CompanyGroup.select("name").where("id = ?", alert.company_group_id).first
      return "FOLDER: #{cg.name} has been created by #{emp.first_name} #{emp.last_name}."
    end
  end

  def employer_email_alert_msg(alert)
    if Rails.env.production?
      host = "https://thehiloproject.com/position_profile/xref/"
    elsif Rails.env.staging?
      host = "https://staging.thehiloproject.com/position_profile/xref/"
    else
      host = "localhost:3000/position_profile/xref/"
    end  
      
    case alert.purpose
    when "wild_card"
      return "A candidate " + link_to(alert.first_name+" "+alert.last_name+" (CS"+alert.job_seeker_id.to_s+")",  host+"CS"+alert.job_seeker_id.to_s+"?position_id="+alert.job_id.to_s) + " has Wildcarded your #{alert.name} (HL#{alert.job_id}) position."
    when "interested"
      return link_to(alert.first_name.to_s+" "+alert.last_name.to_s+" (CS"+alert.job_seeker_id.to_s+")",  host+"CS"+alert.job_seeker_id.to_s+"?position_id="+alert.job_id.to_s) + " has applied for your #{alert.name} (HL#{alert.job_id}) position."
    when "legacy"
      return "Update the information in the redesigned CREDENTIALS section of your positions and re-post them."
    when "best-fit"
      return "A new best fit candidate " + link_to(alert.first_name+" "+alert.last_name+" (CS"+alert.job_seeker_id.to_s+")",  host+"CS"+alert.job_seeker_id.to_s+"?position_id="+alert.job_id.to_s) + " for #{alert.name} (HL#{alert.job_id}) has been identified."
    when "better-fit"
      return "A new better fit candidate "+ link_to(alert.first_name+" "+alert.last_name+" (CS"+alert.job_seeker_id.to_s+")",  host+"CS"+alert.job_seeker_id.to_s+"?position_id="+alert.job_id.to_s) + " for #{alert.name} (HL#{alert.job_id}) has been identified."
    when "good-fit"
      return "A new good fit candidate " + link_to(alert.first_name+" "+alert.last_name+" (CS"+alert.job_seeker_id.to_s+")",  host+"CS"+alert.job_seeker_id.to_s+"?position_id="+alert.job_id.to_s) + " for #{alert.name} (HL#{alert.job_id}) has been identified."
    when "expiry"
      return "Your currently active position #{alert.name} is about to expire."
    when "sub-deleted"
      return "#{fetch_employer_name(alert)} has deleted his account."
    when "ics-deleted"
      return "Internal Candidate #{fetch_job_seeker_name(alert)} has deleted his account."
    when "cs-purchased-deleted"
      return "Career Seeker #{fetch_job_seeker_name(alert)} whose profile you had purchased has deleted his account."
    when "job-active"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "#{alert.name} has been activated by #{emp.first_name} #{emp.last_name}."
    when "job-inactive"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "#{alert.name} has been de-activated by #{emp.first_name} #{emp.last_name}."
    when "job-edit"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "#{alert.name} has been edited by #{emp.first_name} #{emp.last_name}."
    when "job-delete"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "#{alert.name} has been deleted by #{emp.first_name} #{emp.last_name}."
    when "job-re-assign"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      return "#{alert.name} has been assigned to #{fetch_job_employers_name(alert)} by #{emp.first_name} #{emp.last_name}."
    when "folder-reassign"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      new_emp = Employer.select("first_name, last_name").where("id = ?", alert.employer_id).first
      return "#{alert.folder_name} has been assigned to #{new_emp.first_name} #{new_emp.last_name} by #{emp.first_name} #{emp.last_name}."
    when "folder-create"
      emp = Employer.with_deleted.select("first_name, last_name").where("id = ?", alert.employer_job_activity).first
      cg = CompanyGroup.select("name").where("id = ?", alert.company_group_id).first
      return "#{cg.name} has been created by #{emp.first_name} #{emp.last_name}."
    end
  end

  def cover_note?(alert,flag)
    p alert.purpose
    if alert.purpose == "interested"
      job_status = JobStatus.with_deleted.where(:job_id=>alert.job_id,:job_seeker_id=>alert.job_seeker_id).first

      unless job_status.cover_note.nil?
        if flag
          return ("&cover_job_id="+alert.job_id.to_s).html_safe
        else
          return ("?cover_job_id="+alert.job_id.to_s).html_safe
        end
      end
    end
    
  end

  def is_notification_job_active?(job_id)
    if session[:employer].account_type_id != 3
      job = Job.where("jobs.id = ? and jobs.employer_id IN (#{session[:employer].subtree_ids.join(',')}) and jobs.deleted = ?", job_id, false).first
    else
      job = Job.where("jobs.id = ? and jobs.employer_id IN (#{session[:employer].id}) and jobs.deleted = ?", job_id, false).first
    end
    return true unless job.nil?
    return false
  end

  def prepare_list_of_children(c)
    last = initial_finder(c.last_name)
    str = content_tag(:li, c.first_name + " " + last, :emp_id => c.id, :onclick => "fetch_employer_position(#{c.id}, this)")
  end

  def initial_finder(name)
    arr = name.split""
    return arr[0] + "."
  end

  def self.initial_finder_emp(name)
    arr = name.split""
    return arr[0] + "."
  end

  def fetch_children_list(c)
    content_tag(:li, (c.first_name + " " + initial_finder(c.last_name)).upcase, :emp_id=>c.id)
  end

  def fetch_children_last(c)
    content_tag(:li, (c.first_name + " " + initial_finder(c.last_name)).upcase, :emp_id=>c.id, :class=>"last")
  end

  def prepare_search_career_seeker(ids)
    content_tag(:ul, :class=> "options") do
      ids.each do |id|
        ss = CareerSeekerSavedSearch.find_by_id(id)
        if ss.deleted == false
          concat content_tag(:li, content_tag(:label, ss.name, :keyword=>ss.keyword) + link_to("","javascript:void(0);",:class=>"remove_button",:onclick=>"deleteSavedSearch(this, event);",:id=>id), :selected=>"", :onclick=>"copyToTextBox(this);unbindKeydown();")
        end
      end
    end
  end

  def prepare_search_employer(ids)
    content_tag(:ul, :class=> "options") do
      ids.each do |id|
        emp_search = EmployerSavedSearch.find_by_id(id)
        if emp_search.deleted == false
          concat content_tag(:li, content_tag(:label, emp_search.name, :keyword=>emp_search.keyword) + link_to("","javascript:void(0);",:class=>"remove_button",:onclick=>"deleteSavedSearch(this, event);",:id=>id), :selected=>"", :onclick=>"copyToTextBox(this);unbindKeydown();")
        end
      end
    end
  end

  def prepare_folders(jobs, cat_id, cat_name)
    content_tag(:div, content_tag(:span, cat_name, :class=>"user-name"), :class=>"top") +
      content_tag(:div, content_tag(:div, position_list(jobs, cat_id), :class=>"middle").concat(content_tag(:div, "" ,:class=>"bottom")), :class=>"slide")
  end

  def position_list(jobs, c)
    content_tag :ul do
      jobs.each do |j|
        if j.group_id == c
          if j.deleted == false
            concat content_tag(:li, j.job_name, :class=>(j.active == 1 and j.expire_at > DateTime.now.utc) ? j.internal == 1 ? "yellow" : "green" : "red", :id=>"job_"+j.job_id.to_s)
          end
        end
      end
    end
  end

  def fetch_company(notification)
    Company.with_deleted.find(notification.company_id)
  end

  def fetch_job(notification)
    Job.with_deleted.find(notification.job_id)
  end

  def fetch_employer_name(alert)
    emp = Employer.with_deleted.find(alert.deleted_employer_id)
    [emp.first_name, emp.last_name].join(' ')
  end

  def fetch_job_seeker_name(alert)
    js = JobSeeker.with_deleted.find(alert.job_seeker_id)
    [js.first_name, js.last_name].join(' ')
  end

  def fetch_job_employers_name(alert)
    job = Job.with_deleted.find_by_id(alert.job_id)
    emp = Employer.with_deleted.find_by_id(job.employer_id)
    [emp.first_name, emp.last_name].join(' ')
  end

  def job_seeker_alert_msg(notification)
    if notification.notification_type.id == 3
      case notification.notification_message.id
      when 5
        return fetch_company(notification).name + " has purchased your proﬁle in relation to their " + fetch_job(notification).name + " position."
      when 6
        return "A new position " + fetch_job(notification).name + " has been posted by " + fetch_company(notification).name + " which you are following. Click here to see more."
      when 7
        return "You are a " + get_pairing_value_for_job_seeker(session[:job_seeker].id,fetch_job(notification).id) + " for #{fetch_job(notification).name} with #{fetch_job(notification).hiring_company == 0 ? fetch_job(notification).hiring_company_name : fetch_company(notification).name} . Click to view the Position Preview."
      when 8
        return "You were actually a " + get_pairing_value_for_job_seeker(session[:job_seeker].id,fetch_job(notification).id) + " for #{fetch_job(notification).name} with #{fetch_job(notification).hiring_company == 0 ? fetch_job(notification).hiring_company_name : fetch_company(notification).name} . Click to view the Position Preview."
      when 10
        return "A new best fit position " + fetch_job(notification).name + " has been posted by " + fetch_company(notification).name + ". Click here to see more."
      when 11, 12
        return "A new good/better fit position " + fetch_job(notification).name + " has been posted by " + fetch_company(notification).name + ". Click here to see more."
      when 13
        return "The position for " + fetch_job(notification).name + " posted by " + fetch_company(notification).name + " has been closed."
      when 14
        return "A best ﬁt position " + fetch_job(notification).name + " has been updated by " + fetch_company(notification).name + ". Click here to see more."
      when 15, 16
        return "A good/better fit position " + fetch_job(notification).name + " has been updated by " + fetch_company(notification).name + ". Click here to see more."
      when 17
        return "A position has been updated by " + fetch_company(notification).name + " which you are following. Click here to see more."
      end
    else
      return notification.notification_message.message
		end
  end

  def job_seeker_email_alert_msg(notification)
    if notification.notification_type.id == 3
      case notification.notification_message.id
      when 5
        return fetch_company(notification).name + " has purchased your proﬁle in relation to their " + fetch_job(notification).name + " position."
      when 6
        return "A new position " + fetch_job(notification).name + " has been posted by " + fetch_company(notification).name + " which you are following."
      when 7
        return "You are a " + get_pairing_value_for_job_seeker(session[:job_seeker].id,fetch_job(notification).id) + " for #{fetch_job(notification).name} with #{fetch_job(notification).hiring_company == 0 ? fetch_job(notification).hiring_company_name : fetch_company(notification).name} ."
      when 8
        return "You were actually a " + get_pairing_value_for_job_seeker(session[:job_seeker].id,fetch_job(notification).id) + " for #{fetch_job(notification).name} with #{fetch_job(notification).hiring_company == 0 ? fetch_job(notification).hiring_company_name : fetch_company(notification).name} ."
      when 10
        return "A new best fit position " + fetch_job(notification).name + " has been posted by " + fetch_company(notification).name + "."
      when 11, 12
        return "A new good/better fit position " + fetch_job(notification).name + " has been posted by " + fetch_company(notification).name + "."
      when 13
        return "The position for " + fetch_job(notification).name + " posted by " + fetch_company(notification).name + " has been closed."
      when 14
        return "A best ﬁt position " + fetch_job(notification).name + " has been updated by " + fetch_company(notification).name + "."
      when 15, 16
        return "A good/better fit position " + fetch_job(notification).name + " has been updated by " + fetch_company(notification).name + "."
      when 17
        return "A position has been updated by " + fetch_company(notification).name + " which you are following."
      end
    else
      return notification.notification_message.message
		end
  end
  
  def dashboard_location(zip)
    #logger.info("***********************************#{zip}")
    obj = Zipcode.find_by_zip(zip)
    #logger.info("***********************************#{obj}")
    if !obj.nil?
      return obj.city + ", " + obj.state
    else
      return " "
    end
    
  end
  
  def current_selected_job(item)
    if not @job.nil?
      (item.job_id.to_i == @job.id) ? 'current-selected-job' : ''
    end
  end
  
  def seeker_account_link
    if session[:job_seeker].activated == true
      return link_to("Account",{:controller=>"my_account"})
    else
      return "<span class='account-inactive-link'>Account</span>"
    end
  end
  
  def get_jobs_within_group(item)
    @jobs_within_group= Job.where("company_group_id=? and deleted=? ", item.group_id, false).all
    return @jobs_within_group.length
  end
  
  def pairing_text_return_msg(curr_controller, curr_action)
    if curr_controller =="account" and curr_action == "index"
      return "Return to My account"
    elsif curr_controller =="account" and curr_action == "pairing_profile"
      return "Return to Pairing Profile"
    elsif curr_controller =="account" and curr_action == "opportunities"
      return "Return to Opportunities"
    elsif curr_controller =="hilo_search" and curr_action == "index"
      return "Return to Hilo Search"
    elsif curr_controller =="position_profile" and curr_action == "candidate_pool"
      return "Return to Candidate Pool"
    else
      return "Return"
    end
        
  end
  
  def pairing_text_with_color(txt,color)
    "<span class='#{color}_birk'>#{txt.upcase}</span>"
  end
  
  def value_per_posting
    return "<span class='birkman-msg-no-msg'>{Value Calculated Per Posting}</span>"
  end
 
=begin job_workenv_txt_by_score - previous definition
  def job_workenv_txt_by_score(job)
    x_score, y_score = job.work_env_score
    trait, color = WorkenvQuestion.text_and_color_by_score(x_score, y_score)
    if trait.blank?
          return value_per_posting
    else
          return "<a href='javascript:void(0);' class='#{color}_birk' onclick='show_pairing_color_desc(\"#{color}\",\"#{trait}\",\"emp\",\"work\");'>#{trait.upcase}</a>"
    end
  end
=end

  def job_workenv_txt_by_score(job)
    x_score, y_score = job.work_env_score
    trait, color = WorkenvQuestion.text_by_score(x_score, y_score)
    if trait.blank?
      return "{Value Calculated Per Posting}"
    else
      return "#{trait.upcase}"
    end
  end

=begin
  def job_role_txt_by_score(job)
    x_score, y_score = job.role_score
    trait, color = RoleQuestion.text_and_color_by_score(x_score, y_score)
    if trait.blank?
          return "{Value Calculated Per Posting}"
    else
          return "<a href='javascript:void(0);' class='#{color}_birk' onclick='show_pairing_color_desc(\"#{color}\",\"#{trait}\",\"emp\",\"role\");'>#{trait.upcase}</a>"
    end
  end
=end

  def job_role_txt_by_score(job)
    x_score, y_score = job.role_score
    trait = RoleQuestion.text_by_score(x_score, y_score)
    if trait.blank?
      return "{Value Calculated Per Posting}"
    else
      return "#{trait.upcase}"
    end
  end
    
=begin
  def seeker_workenv_txt_by_score(js_birkman_detail)
    trait, color = WorkenvQuestion.text_and_color_by_score(js_birkman_detail.grid_work_environment_x,js_birkman_detail.grid_work_environment_y)
     if trait.blank?
          return "<span class='birkman-msg-no-msg'>{Value Calculated Per Career Seeker}</span>"
    else
          return "<span style='font-size: 13px;'>#{vowel_a_an(trait)}</span>" + " <a href='javascript:void(0);' class='#{color}_birk' onclick='show_pairing_color_desc(\"#{color}\",\"#{trait}\",\"seeker\",\"work\");'>#{trait.upcase}</a>"
    end
  end
=end
  
  def seeker_workenv_txt_by_score(js_birkman_detail)
    trait = WorkenvQuestion.text_by_score(js_birkman_detail.grid_work_environment_x,js_birkman_detail.grid_work_environment_y)
    if trait.blank?
      return "{Value Calculated Per Career Seeker}"
    else
      return "#{trait.upcase}"
    end
  end
  
=begin  seeker_role_txt_by_score - previous definition
  def seeker_role_txt_by_score(js_birkman_detail)
    trait, color = RoleQuestion.text_and_color_by_score(js_birkman_detail.grid_work_role_x,js_birkman_detail.grid_work_role_y)
     if trait.blank?
          return "<span class='birkman-msg-no-msg'>{Value Calculated Per Career Seeker}</span>"
    else
          return "<span style='font-size: 13px;'>#{vowel_a_an(trait)}</span>" + " <a href='javascript:void(0);' class='#{color}_birk' onclick='show_pairing_color_desc(\"#{color}\",\"#{trait}\",\"seeker\",\"role\");'>#{trait.upcase}</a>"
    end
  end
=end
  
  def seeker_role_txt_by_score(js_birkman_detail)
    trait = RoleQuestion.text_by_score(js_birkman_detail.grid_work_role_x,js_birkman_detail.grid_work_role_y)
    if trait.blank?
      return "{Value Calculated Per Career Seeker}"
    else
      return "#{trait.upcase}"
    end
  end
  def vowel_a_an(trait)
    trait.downcase == "analyzer" ? "an" : "a"
  end
  
  def footer_bg
    if (controller.controller_name == "account" and controller.action_name == "index") or (controller.controller_name == "account" and controller.action_name == "opportunities") or (controller.controller_name == "employer_account" and controller.action_name == "index") or (controller.controller_name == "position_profile" and ["edit","new","view","basics","work_env","role","credentials","candidate_pool"].include?(controller.action_name))
      return "footer-bg-left"
    else
      return "footer-bg"
    end
  end
  
  def formatted_time_in_est(time_obj)
    time_obj.in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%Y %H:%M") + " EST"
  end
  
  def checktime i
    str = i.to_s
    if i<10
      str = "0" + str
    end
    return str
  end
  
  def format_remaining_time(time_obj)
    q_day = 1;   q_hr = 0;   q_min = 0;   q_sec = 0
    return "Expired" if Time.now.utc.to_i > time_obj.to_i
        
      
    seconds_diff = (Time.now.utc.to_i - time_obj.to_i).abs
    q_day, r_day = seconds_diff.divmod(24 * 60 * 60)
      
    if r_day > 0
      q_hr, r_hr = r_day.divmod(60 * 60)
          
      if r_hr > 0
        q_min, r_min = r_hr.divmod(60)
        q_sec = r_min  #r_min is the remaining seconds
      end
    end
      
    "<b><span id='days'>#{checktime(q_day)}</b></span>d <b><span id='hours'>#{checktime(q_hr)}</span></b>h <b><span id='minutes'>#{checktime(q_min)}</span></b>m <b><span id='seconds'>#{checktime(q_sec)}</span></b>s".html_safe.force_encoding('utf-8')
  end
  
  def format_remaining_time_js(time_obj)
    seconds_diff = (Time.now.utc.to_i - time_obj.to_i).abs
    q_day, r_day = seconds_diff.divmod(24 * 60 * 60)
      
    if r_day > 0
      q_hr, r_hr = r_day.divmod(60 * 60)
          
      if r_hr > 0
        q_min, r_min = r_hr.divmod(60)
        q_sec = r_min  #r_min is the remaining seconds
      end
    end
    return checktime(q_day),checktime(q_hr),checktime(q_min),checktime(q_sec)
  end
  
  def format_remaining_time_emp(time_obj)
    q_day = 1;   q_hr = 0;   q_min = 0;   q_sec = 0
    return "Expired" if Time.now.utc.to_i > time_obj.to_i


    seconds_diff = (Time.now.utc.to_i - time_obj.to_i).abs
    q_day, r_day = seconds_diff.divmod(24 * 60 * 60)

    if r_day > 0
      q_hr, r_hr = r_day.divmod(60 * 60)

      if r_hr > 0
        q_min, r_min = r_hr.divmod(60)
        q_sec = r_min  #r_min is the remaining seconds
      end
    end

    "<span id='days_2'>#{checktime(q_day)}</span>d <span id='hours_2'>#{checktime(q_hr)}</span>h <span id='minutes_2'>#{checktime(q_min)}</span>m <span id='seconds_2'>#{checktime(q_sec)}</span>s"
  end
  
  def pos_profile_tab_selected(current_tab,tab_val)
    return  current_tab ==  tab_val ? " pos-prof-tab-selected" : "pos-prof-tab-inactive"
  end
  
  def pos_create_tab_selected(current_tab,tab_val)
    return  current_tab ==  tab_val ? " pos-create-tab-selected" : ""
  end
  
  def pos_profile_create_done()
      
  end
  
  def show_share_hilo_success
    if session[:hilo_shared_success]
      session[:hilo_shared_success]  = nil
      return "eval(\"share_hilo.success_msg('Hilo shared successfully')\");"
    end
  end
    
  def compensation_range_by_value(val)
    first_val = val
    val_index = $compensation_values.index(val.to_i)
      
    if val_index.nil?
      return ""
    end
      
    sec_val = $compensation_values[val_index + 2]
    if not sec_val.nil?
      if first_val.to_i == 200
        return "$200,000 - $300,000+"
      elsif first_val.to_i == 250
        return "$250,000 - $250,000+"
      else
        return "$#{first_val.to_i},000 - $#{sec_val.to_i},000"
      end
    else
      return "$#{first_val.to_i},000"
    end
  end
  
  def show_job_after_job_pay_load
    if session[:job_pay_job_id]
      str =  "eval(\"show_job.call(#{session[:job_pay_job_id]});\")"
      session[:job_pay_job_id]  = nil
      return str
    end
  end
    
  def old_transaction_detail(payment_obj,promo_code_obj)
    if payment_obj.blank?
      return ""
    else
      if !promo_code_obj.blank?
        return "Redeem From My Account Balance of [$#{(promo_code_obj.amount - promo_code_obj.consumed_amount)}]"
      elsif [$payment_mode[:pro],$payment_mode[:pro_promo]].include?(payment_obj.payment_mode)
        return "(Credit Card ************#{payment_obj.card_number})"
      elsif [$payment_mode[:express],$payment_mode[:express_promo]].include?(payment_obj.payment_mode)
        return "(My PayPal Account)"
      end
    end
    return ""
  end
  
  def show_social_share_link
    if (controller.controller_name == "account" and controller.action_name == "index") or (controller.controller_name == "employer_account" and controller.action_name == "index")
      return false
    else
      return !["home"].include?(controller.controller_name)
    end
    return true
  end
  
  def show_gift_payment_msg_onload
    if not session[:gift_complete].blank?
      if session[:gift_complete] == true
        str =  "eval(\"job_view_pay.success_msg('Gift card sent');\")"
      else
        str =  "eval(\"show_message.show_message('Payment failed');\")"
      end
      session[:gift_pay] = session[:job_view_pay] = session[:gift_complete]  = nil
      return str
    end
    session[:gift_pay] = session[:job_view_pay] = session[:gift_complete]  = nil
  end
    
    
  def  show_job_payment_msg_onload
    if not session[:payment_complete].blank?
      if session[:payment_complete] == true
        str =  "eval(\"job_view_pay.success_msg('Payment successful');\")"
      else
        str =  "eval(\"show_message.show_message('Payment failed');\")"
      end
      session[:gift_pay] = session[:job_view_pay] = session[:payment_complete]  = nil
      return str
    end
    session[:gift_pay] = session[:job_view_pay] = session[:payment_complete]  = nil
  end
  
  def pay_for_job_message(pay_for)
    msg = ""
    case pay_for
    when "consider"
      msg = "See Position Details for $#{JOB_DETAIL_VIEW_COST}"
    when "interest"
      msg = "Express interest in this post for $#{JOB_EXPRESS_INTEREST_COST}"
    when "wild"
      msg = "Take wild card on this job for $#{JOB_WILD_CARD_COST}"
    end
    return msg
  end
  
  def hide_home_page_onload
    (controller.controller_name == "home" and controller.action_name == "index") ? "display:none;" : ""
  end

  def show_header
    (controller.controller_name == "home" and controller.action_name == "index") ? false : true
  end
  
  def show_footer
    (controller.controller_name == "home" and controller.action_name == "index") ? false : true
  end
  
  def workenv_img_by_section(img_section)
    case img_section
    when "workenv_top_left"
      src = "/assets/workenv_top_left.png"
    when "workenv_top_right"
      src = "/assets/workenv_top_right.png"
    when "workenv_bottom_left"
      src = "/assets/workenv_bottom_left.png"
    when "workenv_bottom_right"
      src = "/assets/workenv_bottom_right.png"
    end
    return src
  end

  def workenv_text_by_section(img_section) 
    if session[:employer]
      case img_section
      when "workenv_top_left"
        str = "The RED Work Environment"
      when "workenv_top_right"
        str= "The GREEN Work Environment"
      when "workenv_bottom_left"
        str = "The YELLOW Work Environment"
      when "workenv_bottom_right"
        str = "The BLUE Work Environment"
      end
    else
      str =""
    end
      
    return str
  end
  
  def role_position_table_header(img_section)
    if session[:employer]
      case img_section
      when "role_top_left"
        str = "The RED Role should offer a Career Seeker the ability to:"
      when "role_top_right"
        str = "The GREEN Role should offer a Career Seeker the ability to:"
      when "role_bottom_left"
        str = "The YELLOW Role should offer a Career Seeker the ability to"
      when "role_bottom_right"
        str = "The BLUE Role should offer a Career Seeker the ability to"
      end
    else
      case img_section
      when "role_top_left"
        str = "The RED Role should offer you the ability to:"
      when "role_top_right"
        str = "The GREEN Role should offer you the ability to:"
      when "role_bottom_left"
        str = "The YELLOW Role should offer you the ability to"
      when "role_bottom_right"
        str = "The BLUE Role should offer you the ability to"
      end
    end
    return str
  end
  
  def role_img_by_section(img_section)
    case img_section
    when "role_top_left"
      src = "/assets/role_top_left.png"
    when "role_top_right"
      src = "/assets/role_top_right.png"
    when "role_bottom_left"
      src = "/assets/role_bottom_left.png"
    when "role_bottom_right"
      src = "/assets/role_bottom_right.png"
    end
    return src
  end   
  
  def role_text_by_section(img_section) 
    case img_section
    when "role_top_left"
      str = "RED Role \"The Doer\""
    when "role_top_right"
      str= "GREEN Role \"The Talker\""
    when "role_bottom_left"
      str = "YELLOW Role \"The Counter\""
    when "role_bottom_right"
      str = "BLUE Role \"The Thinker\""
    end
    return str
  end
  
  def workenv_text_for_table_header(img_section)
    if session[:employer]
      case img_section
      when "workenv_top_left"
        str = "The RED Work Environment"
      when "workenv_top_right"
        str= "The GREEN Work Environment"
      when "workenv_bottom_left"
        str = "The YELLOW Work Environment"
      when "workenv_bottom_right"
        str = "The BLUE Work Environment"
      end
    else
      case img_section
      when "workenv_top_left"
        str = "A Red Work Environment will..."
      when "workenv_top_right"
        str= "A Green Work Environment will..."
      when "workenv_bottom_left"
        str = "A Yellow Work Environment will..."
      when "workenv_bottom_right"
        str = "A Blue Work Environment will..."
      end
    end
          
    return str
  end
     
  def role_text_for_table_header(img_section)
    if session[:employer]
      case img_section
      when "role_top_left"
        str = "The RED Role should..."
      when "role_top_right"
        str= "The GREEN Role should..."
      when "role_bottom_left"
        str = "The YELLOW Role should..."
      when "role_bottom_right"
        str = "The BLUE Role should..."
      end
    else
      case img_section
      when "role_top_left"
        str = "A Red Role will..."
      when "role_top_right"
        str= "A Green Role will..."
      when "role_bottom_left"
        str = "A Yellow Role will..."
      when "role_bottom_right"
        str = "A Blue Role will..."
      end
    end
          
    return str
  end
  
  def preferred_mark(type, val)
    (val == type) ? "<span style='font-weight:normal;'>(Preferred)</span>" : "&nbsp;"
  end
     
  def preferred_checked(type, val)
    (val == type) ? "checked='checked'" : ""
  end
  
  def youtube_video_id(url)
    str = ""
    if not url.blank?
      temp_str = url.split("v=")[1]
      if not temp_str.blank?
        str = temp_str.split("&")[0]
      else
        str = url.split("youtu.be/")[1]
      end
    end
    return str
  end
  
  def signin_link
    if session[:job_seeker]
      return "<a href=\"/login/logout\">Sign Out</a>"
    elsif session[:employer]
      return "<a href=\"/login/logout\" class=\"button-a buttton_65X23\">Sign Out</a>"
    else
      return "<a href=\"javascript:void(0);\" onclick=\"show_login('signin',event);\" class=\"stop-propogate\">Sign In</a>"
    end
  end
  
  def mark_read(job_id,job_statuses)
    str = "unread"
    if job_statuses.has_key?(job_id.to_s)
      if !job_statuses[job_id.to_s][:read_flag].blank? and job_statuses[job_id.to_s][:read_flag] == true
        str = ""
      end
    end
    str
  end
  
  def unread_dot(job_id,job_statuses)
    str = image_tag("bullet-blue-active.png",:size=>"11x12",:alt=>"Bullet")
      
    if job_statuses.has_key?(job_id.to_s)
      if !job_statuses[job_id.to_s][:read_flag].blank? and job_statuses[job_id.to_s][:read_flag] == true
        str = "&nbsp;"
      end
    end
    str
  end
  
  #~ def paid_icons(job_id,job_statuses)
  #~ str =  ""
  #~ if job_statuses.has_key?(job_id.to_s)
  #~ if !job_statuses[job_id.to_s][:considering].blank? and job_statuses[job_id.to_s][:considering] == true
  #~ str << "<img src='/assets/detail_paid.jpg'/> "
  #~ end
              
  #~ if !job_statuses[job_id.to_s][:interested].blank? and job_statuses[job_id.to_s][:interested] == true
  #~ str << "<img src='/assets/express_interest_paid.jpg'/> "
  #~ end
            
  #~ if !job_statuses[job_id.to_s][:wild_card].blank? and job_statuses[job_id.to_s][:wild_card] == true
  #~ str << "<img src='/assets/wild_card_paid.jpg'/> "
  #~ end
  #~ end
          
  #~ return str.blank? ?  "&nbsp;" : str
  #~ end
  
  
  def job_row_attr_considering(job_id,job_statuses)
    str = "data-consider='no'"
    if job_statuses.has_key?(job_id.to_s)
      if !job_statuses[job_id.to_s][:considering].blank? and job_statuses[job_id.to_s][:considering] == true
        str = "data-consider='yes'"
      end
    end
    str
  end

  def get_status_value(visitor)
    if(visitor.wild_card || visitor.interested)
      return "Applied" if visitor.wild_card
      return "Applied" if visitor.interested
    elsif(visitor.considering)
      return "Detail"
    elsif(visitor.read)
      return "Preview"
    else
      return "---"
    end
    #wildcard interested considering read
  end

  def show_cosidering_cost(cnt)
    sprintf('%.2f', cnt * JOB_DETAIL_VIEW_COST)
  end
  
  def show_interested_cost(cnt)
    sprintf('%.2f', cnt * JOB_EXPRESS_INTEREST_COST)
  end
  
  def show_wild_card_cost(cnt)
    sprintf('%.2f', cnt * JOB_WILD_CARD_COST)
  end
  
  def href_for_logo
    if !session[:job_seeker].blank? and session[:job_seeker].completed_registration_step == PAYMENT_STEP
      return "/account"
    elsif !session[:employer].blank? and session[:employer].completed_registration_step == EMPLOYER_PAYMENT_STEP
      return "/employer_account"
    else
      return "/home"
    end
  end
  
  
  def job_address_in_listing(item)
    address = []
    if not item.street_one.blank?
      address << item.street_one.to_s
    end
    
    if not item.city.blank?
      address << item.city.to_s
    end
    if address.blank?
      address << "&nbsp;"
    end
    
    return address.join(",")
  end
  
  def facebook_job_url(job)
    return "https://www.facebook.com/sharer.php?u=http%3A%2F%2Fwww.thehiloproject.com/job/#{job.id}/2&t=Job%20on%20Hilo%20" + CGI::escape( job.name)
  end
    
  def twitter_job_url(job)
    return "https://twitter.com/home?status=Job%20on%20Hilo%20#{CGI::escape( job.name)}%20http%3A%2F%2Fwww.thehiloproject.com/job/#{job.id}/1"
  end
  
  def linkedin_job_url(job)
    return "https://www.linkedin.com/shareArticle?mini=true&title=#{CGI::escape( job.name)}&url=http%3A%2F%2Fwww.thehiloproject.com/job/#{job.id}/3&summary=" + CGI::escape( job.name) + "&source=thehiloproject.com"
  end
    
  def facebook_networking_url #this fucntion is no more is use
    return "https://www.facebook.com/sharer.php?u=http%3A%2F%2Fwww.thehiloproject.com&t=" + social_networking_msg()
  end
  
  def twitter_networking_url #this fucntion is no more is use
    #Currently%20reading http%3A%2F%2Fwww.thehiloproject.com
    return "https://twitter.com/home?status=" + social_networking_msg()
  end
    
  def linkedin_networking_url #this fucntion is no more is use
    return "https://www.linkedin.com/shareArticle?mini=true&title=Project%20Hilo&url=http%3A%2F%2Fwww.thehiloproject.com&summary=" + social_networking_msg() + "&source=thehiloproject.com"
  end  
  
  def social_networking_msg(escape = true)
    msg ="Hi!

I just joined the first ever human-centered employment site https://thehiloproject.com. You should check it out. It matches you to jobs based on your personality as well as your experience and credentials.

Good luck!
    "
    return escape ? CGI::escape(msg) : msg
  end

  def job_sharing_msg(job,escape = true )
    msg ="Hi!
  
I just joined the first ever human-centered employment site https://thehiloproject.com. I saw this job and thought you might be interested.

Company Name: #{job.company.name.to_s}
Position: #{job.name.to_s}
Job Code: #{job.code}
Overview: #{truncate(job.summary.to_s, :length => 305, :omission => ' ...', :separator => ' ')}

If you don't already know about Hilo, it matches you to jobs based on your personality as well as your experience and credentials.

Good luck!
    "
    return escape ? CGI::escape(msg) : msg
  end
  
  def json_from_flashnotice (notice)
    return  "[{'key':'flash', 'msg':'#{notice}'}]"
  end
   
  def last_login
    session[:last_login] ||= Time.now
    session[:last_login].strftime("%m/%d/%y") + " - " + Time.now.strftime("%m/%d/%y")
  end
   
  def since_registration
    session[:employer].created_at.strftime("%m/%d/%y") + " - " + Time.now.strftime("%m/%d/%y")
  end
   
  def since_job_created(job)
    job.created_at.strftime("%m/%d/%y") + " - " + Time.now.strftime("%m/%d/%y")
  end

  def get_time_formate(notification_on)
    diff = DateTime.now - notification_on.beginning_of_day.to_datetime
    diff = diff.to_i
    
    if notification_on.today?
      day = "TODAY"
    elsif diff == 1
      day = "YESTERDAY"
    else
      day = notification_on.strftime("%m.%d.%Y")
    end
    return day
  end

  def get_pairing_value_for_job_seeker(job_seeker_id, job_id)
    pairing = PairingLogic.with_deleted.select("pairing_value").where("job_seeker_id = #{job_seeker_id} and job_id = #{job_id}").first
    pairing = pairing.pairing_value
    if pairing > 4 
      return "best fit"
    elsif pairing > 3 and pairing <= 4
      return "better fit"
    elsif pairing > 2 and pairing <= 3
      return "good fit"
    else
      return "wildcard"
    end
  end

  def payment_type_text(type)
    if type == "seeker_registration"
      return "Site Activation"
    elsif type == "job_detail_view"
      return "Position Details"
    elsif type == "job_wild"
      return "Wildcard"
    elsif type == "job_interest"
      return "Indicate Interest"
    elsif type == "gift"
      return "Gift Hilo"
    elsif type == "purchase_profile"
      return "Purchased Profile"
    elsif type == "employer_registration"
      return "Site Activation"
    end
  end

  def self.payment_text_type(type)
    if type == "seeker_registration"
      return "Site Activation"
    elsif type == "job_detail_view"
      return "Position Details"
    elsif type == "job_wild"
      return "Wildcard"
    elsif type == "job_interest"
      return "Indicate Interest"
    elsif type == "gift"
      return "Gift Hilo"
    elsif type == "purchase_profile"
      return "Purchased Profile"
    elsif type == "employer_registration"
      return "Site Activation"
    end
  end

  def parse_tree(node,tree_structure = "")
    node.each_pair do |k,v|
      tree_structure = tree_structure + "<li class='me-node' id='map_emp_"+k.id.to_s+"'>ME"
      if !v.blank?
        tree_structure = parse_children(v,tree_structure)
      end
      tree_structure = tree_structure + "</li>"
    end
    return tree_structure
  end
  def parse_children(node,tree_structure)
    tree_structure = tree_structure + "<ul>"
    node.each_pair do |k,v|
      if k.depth == 1 and k.has_children?
        class_name = "collapsed even"
      elsif k.depth%2 == 0
        class_name = "odd"
      else
        class_name = "even"
      end
      user_name = k.first_name+" "+initial_finder(k.last_name)
      user_name = truncate(user_name, :length => 13, :omission => '...')
      tree_structure = tree_structure + "<li id='map_emp_"+k.id.to_s+"' class='"+class_name+"'><span>"+user_name+"</span>"
      if !v.blank?
        tree_structure = parse_children(v,tree_structure)
      end
      tree_structure = tree_structure + "</li>"
    end
    tree_structure = tree_structure + "</ul>"
    return tree_structure
  end

  def twitter_text(flag)
    if flag
      return "Re-tweet it."
    else
      return "Tweet it."
    end
  end

  def facebook_text(flag)
    if flag
      return "Re-post to your<br>company's Facebook page."
    else
      return "Share on your<br>company's Facebook page."
    end
  end

  def linkedin_text(flag)
    if flag
      return "Re-post to your<br>company's LinkedIn wall."
    else
      return "Post to your<br>company's LinkedIn wall."
    end
  end

  def sharing_tick(platform_id,flag)
    if platform_id == 1
      margin_value = "6"
    else
      margin_value = "-8"
    end
    if flag
      return '<span id="'+platform_id.to_s+'_post_image" style="float: right; margin-top: '+margin_value+'px;"><img src="/assets/employer_v2/click.png" alt="hilo"/></span>'
    else
      return '<span id="'+platform_id.to_s+'_post_image" style="display:none; float: right; margin-top: '+margin_value+'px;"><img src="/assets/employer_v2/click.png" alt="hilo"/></span>'
    end
  end

  def job_switch_labels(label, value)
    if label == "inactive" and value == 1
      return "selected"
    elsif label == "internal" and value == 2
      return "selected"
    elsif label == "active" and value == 3
      return "selected"
    end
  end

  def format_role_text(text, length)
    text = word_wrap(text,:line_width => length)
    text = text.gsub(/\n/,"\n\n")
    text = simple_format(text)
    text = text.gsub(/\n\n/,"")
    text
  end

  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://"+$FAYE_URL)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
  
  def language_links
    links = []
    I18n.available_locales.each do |locale|
      locale_key = "translation.#{locale}"
      links << link_to(I18n.t(locale_key), "/ajax/set_locale_session?locale=#{locale}", :remote=>true)
    end
    links
  end

end

