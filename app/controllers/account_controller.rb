# coding: UTF-8

require 'base64'
require 'date'

class AccountController < ApplicationController
  
  before_filter :job_seeker_with_complete_registration, :except => [:seeker_role_for_job, :seeker_workenv_for_job]
  before_filter :authenticate_check, :only=>[:account_info]
  
  layout :determine_layout
  
  def index
    #params[:job_type] ||="dashboard"
    #params[:sort] ||= "fit"
    #params[:order] ||= "desc"
    #@jobs = Job.top_opportunities(session[:job_seeker].id,"fit","desc")
    #@job_statuses = Job.get_job_status(@jobs,session[:job_seeker].id)
    #@count_hash = get_job_count()
    #@notification_count = JobSeekerNotification.find(:all,:conditions=>["job_seeker_id = ? and visibility = ? and new = ?",session[:job_seeker].id,true,true]).size
    #if session[:sharing_sign_up]
    #  log_shared_job_traffic()
    #  log_channel_manager()
    #  session[:sharing_sign_up] = nil
    #end
    redirect_to :controller=>:account,:action=>:opportunities
     
  end

  def search_filter
    if params[:search].present?
      sunspot_str = sunspot_string(params[:search])
      begin
        count = Job.count
        search = Sunspot.search [Job, JobAttachment] do
          fulltext sunspot_str, :minimum_match => 1
          paginate :page => 1, :per_page => count
        end
        search_result = search.results
        @result_arr = Array.new()
        search_result.each do |post|
          if post.class.to_s == "JobAttachment"
            @result_arr << post.job_id
          else
            @result_arr << post.id
          end
        end
      rescue
        render 'search_error', :formats=>[:js], :layout=>false
        return
      end
    end
  end

  def save_alert
    job_seeker = JobSeeker.where(:id => session[:job_seeker].id).first
    job_seeker.alert_threshold = params[:alert_threshhold_val]
    job_seeker.alert_method = params[:alert_method_val]
    job_seeker.notification_email_time = DateTime.now if job_seeker.notification_email_time.nil?
    job_seeker.save(:validate => false)
    reload_seeker_session
    render :text => "Saved"
  end
  
  def following_check_popup
    js = JobSeeker.where(:id=>session[:job_seeker].id).first
    if js.follow_check == false
      render :text => "1"
    else
      render :text => "0"
    end
  end
  
  def bind_follow_button
    job = Job.find(params[:jobid])
    js = JobSeeker.find(session[:job_seeker].id)
      
    if js.follow_check == false and job.hiring_company == false
      render :text => "1"
    else
      render :text => "0"
    end
  end
  
  def set_js_follow_check
    js = JobSeeker.where(:id=>session[:job_seeker].id).first
    if params[:set]
      js.follow_check = params[:set]
      js.save(:validate => false)
    else
      js.follow_check = params[:set]
      js.save(:validate => false)
    end
    render :text => "done"
  end
  
  def opportunities
    params[:id] ||= "inbox"
    params[:sort] ||= "fit"
    params[:order] ||= "desc"
    #@notification_count = JobSeekerNotification.find(:all,:conditions=>["job_seeker_id = ? and visibility = ?",session[:job_seeker].id,true]).size
    @notification_count = JobSeekerNotification.where("job_seeker_id = ? and visibility = ? and new = ?", session[:job_seeker].id, true, true).size
    @count_hash = get_job_count
    if session[:track_shared_job_id] and not session[:job_not_active]
      log_shared_job_traffic()
      @j = Job.find(session[:track_shared_job_id].to_i)
      @js = @j.job_status_for_seeker(session[:job_seeker].id)
      if not @js.blank?
        @this_was_not_read = false
        @js.set_read()
        @js.save
      else
        @this_was_not_read = true
        @js = JobStatus.create({:job_id =>session[:track_shared_job_id].to_i,:job_seeker_id=>session[:job_seeker].id,:read=>true})
        @js.set_read()
        @js.save
      end
    end
    reload_seeker_session
    if session[:job_seeker].credit.nil?
      Credit.create(:job_seeker_id=>session[:job_seeker].id)
    end
    reload_seeker_session
  end
  
  def account_info
    @job_seeker = JobSeeker.where("id=?",session[:job_seeker].id).first
    @old_payment_obj, @promo_code_obj = Payment.job_seeker_old_payment_obj(session[:job_seeker].id,false)
    @notification_count = JobSeekerNotification.where("job_seeker_id = ? and visibility = ? and new = ?", session[:job_seeker].id, true, true).size
    if session[:job_seeker].credit.nil?
      Credit.create(:job_seeker_id=>session[:job_seeker].id)
      reload_seeker_session
    end
  end
  
  def show_ie_popup
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker]).first
    render 'show_ie_popup', :formats=>[:js], :layout=>false
    #    render :update do |page|
    #      page.replace_html "file_upload_ie", :partial=>"/account/file_upload_ie", :locals=>{:job_seeker=>@job_seeker}
    #    end
    return
  end
  
  def save_video_url
    
    #session[:area_code] = params[:area_code]
    #session[:phone_one] = params[:phone_one]
    #session[:contact_email] = params[:contact_email]
    #session[:summary] = params[:summary].strip
    #session[:armed] = params[:armed_forces]
    #session[:preferred_contact] = params[:preferred] == "first" ? "phone_one" : "contact_email"
    #session[:flag] = params[:flag]
    #session[:error] = params[:error]
    
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
    @job_seeker.video_url = params[:video_url]
    
    if  @job_seeker.save(:validate => false)
      reload_seeker_session()
      render 'save_video_url', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #
      #        page.replace_html "video-ajax", :partial=>"/account/profile_video", :locals=>{:job_seeker=>@job_seeker}
      #        page.replace_html "url-container", :partial=>"/account/url_container", :locals=>{:job_seeker=>@job_seeker}
      #        page.call "hideUrlContainer"
      #      end
            
    else
      err_arr = []
      @job_seeker.errors.each{|k,v|
        err_arr << v
      }
      @error_json = json_from_error_arr(err_arr)
      render 'save_video_error', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.replace_html "msg_box.show_error", @error_json
      #      end
            
    end
  end
  
  def persist_values
    session[:area_code] = params[:area_code]
    session[:phone_one] = params[:phone_one]
    session[:contact_email] = params[:contact_email]
    session[:summary] = params[:summary].strip
    session[:armed] = params[:armed_forces]
    session[:preferred_contact] = params[:preferred] == "first" ? "phone_one" : "contact_email"
    session[:flag] = params[:flag]
    session[:error] = params[:error]
    
    render :text => "Done"
    return
  end
  
  def save_name_email
    @js = JobSeeker.where("email = ? and id <> ?", params[:Email],session[:job_seeker].id)
    if @js.blank?
      @job_seeker = JobSeeker.where("id = ?", session[:job_seeker].id).first
      @job_seeker.first_name = params[:first_name]
      @job_seeker.last_name = params[:last_name]
      @job_seeker.email = params[:Email]
      @job_seeker.save(:validate => false)
      reload_seeker_session()
      render 'save_name_email', :formats=>[:js], :layout=>false
    else      
      render 'update_emailexist_error_popup', :formats=>[:js], :layout=>false
    end
    return      
  end
  
  def change_account_pass
    @job_seeker = JobSeeker.where("id = ?", session[:job_seeker].id).first
    old_pwd = JobSeeker.encrypted_password(params[:old_password])
    if old_pwd != @job_seeker.hashed_password
      render 'old_pass_mismatch', :formats=>[:js], :layout=>false
    else
      @job_seeker.password = params[:new_password]
      @job_seeker.save(:validate => false)
      render 'change_password', :formats=>[:js], :layout=>false
    end
    return
  end
  
  def authenticate
    if params[:email] != session[:job_seeker].email
      render 'auth_error_js', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "hideAuthenticationPopup"
      #        page.call "showAuthErr"
      #      end
      return  
    end  
    @job_seeker = JobSeeker.authenticate_job_seeker(params[:email], params[:password])
    if not @job_seeker.blank?
      session[:auth_pass] = true
      render 'auth_success_js', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "toAccount"
      #      end
      return  
    else
      render 'auth_error_js', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "hideAuthenticationPopup"
      #        page.call "showAuthErr"
      #      end
      return
    end
  end

  def authenticate_check
    if request.post? and !params[:authenticity_token].blank?
      return
    end
    if session[:auth_pass].nil?
      respond_to do |format|
        if request.env["HTTP_REFERER"]
          #Commenting
          #session[:account_auth] = true
          if request.env["HTTP_REFERER"].split('/').last != 'account_info'
            format.html {redirect_to :back}
          else
            format.html {redirect_to :controller => 'account'}
          end
        else
          if session[:msg].nil? and session[:success_job_seeker_msg].nil?
            session[:account_auth] = true
            format.html {redirect_to :controller => 'account'}
          else
            format.html{}
          end
        end
      end
    else
      session[:auth_pass] = nil
    end  
  end
  
  def authentication_check
    if session[:auth_pass].nil?
      respond_to do |format|
        if request.env["HTTP_REFERER"]
          size_of = request.env["HTTP_REFERER"].split('/').size
          if request.env["HTTP_REFERER"].split('/')[size_of-1] != "account_info"
            session[:account_auth] = true
            format.html {redirect_to :back}
          else
            #session[:account_auth] = true
            format.html
          end
          
        else
          session[:account_auth] = true
          format.html {redirect_to :controller => 'account'}
        end
      end
    else
      session[:auth_pass] = nil
    end
  end
  
  def profile_tabs
    case params[:step]
    when "Intro"
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
      @job_seeker_languages = JobSeekerLanguage.select("languages.*,job_seeker_languages.*").joins("inner join languages on languages.id = job_seeker_languages.language_id").where("job_seeker_languages.job_seeker_id = ?", @job_seeker.id)
      #@selected_proficiencies = @job_seeker.job_seeker_proficiencies
      @job_seeker_roles = OccupationData.find_by_sql("SELECT `occupation_data`.`title` as `title`, `added_roles`.`education_level_id` as `education_level_id`, `added_roles`.`experience_level_id` as `experience_level_id` FROM `occupation_data` INNER JOIN `added_roles` ON `occupation_data`.`onetsoc_code` = `added_roles`.`code` WHERE `added_roles`.`adder_id` = #{@job_seeker.id} AND `added_roles`.`adder_type` = 'JobSeeker' ORDER BY `added_roles`.`id`")


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
      @job_seeker_certifications = @new_selected_certificates
      @job_seeker_licenses = @new_selected_licenses

      

      render 'intro', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "hideProfileLoader"
      #        page.call "changeStatus"
      #        page.replace_html "skills_ajax", :partial=>"skills_popup"
      #        page.replace_html "ajax", :partial=>"/account/profile_intro", :locals=>{:job_seeker=>@job_seeker}
      #
      #      end
      return
    when "Personality"
      @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
      @job_seeker_birkman_detail =@job_seeker.job_seeker_birkman_detail
      render 'personality', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "hideProfileLoader"
      #        page.replace_html "ajax", :partial=>"/account/profile_personality", :locals=>{:job_seeker=>@job_seeker}
      #      end
      return
    when "Credentials"
      @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
      @selected_certificates = NewCertificate.find_by_sql("SELECT `new_certificates`.`certification_name` as `name`, `job_seeker_certificates`.`order` as `order` FROM `new_certificates` INNER JOIN `job_seeker_certificates` ON `new_certificates`.`id` = `job_seeker_certificates`.`new_certificate_id` WHERE `job_seeker_certificates`.`job_seeker_id` = #{@job_seeker.id}")
      @selected_licenses = License.find_by_sql("SELECT `licenses`.`license_name` as `name`, `job_seeker_certificates`.`order` as `order` FROM `licenses` INNER JOIN `job_seeker_certificates` ON `licenses`.`id` = `job_seeker_certificates`.`license_id` WHERE `job_seeker_certificates`.`job_seeker_id` = #{@job_seeker.id}")
      fetch_all_roles_for_logged_in_seeker()
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

      @selected_colleges = University.find_by_sql("SELECT `universities`.`institution` as `name` FROM `universities` INNER JOIN `added_universities` ON `universities`.`id` = `added_universities`.`university_id` WHERE `added_universities`.`adder_id` = #{@job_seeker.id} AND `added_universities`.`adder_type` = 'JobSeeker'").map{|u| u.name}.join("_cscolg_")
      #@selected_proficiencies = @job_seeker.job_seeker_proficiencies.map{|a|  a.proficiency.name + "__" + a.education_id.to_s + "__" + a.skill_id.to_s}.join("_juskill_")
      @selected_languages = @job_seeker.job_seeker_languages.map{|lang| lang.language.name + "__" + lang.proficiency_val}.join(",")
      @selected_degree = Degree.find_by_sql("SELECT `degrees`.`name` as `name`, `added_degrees`.`degree_status` as `status` FROM `degrees` INNER JOIN `added_degrees` ON `degrees`.`id` = `added_degrees`.`degree_id` WHERE `added_degrees`.`adder_id` = #{@job_seeker.id} AND `added_degrees`.`adder_type` = 'JobSeeker'").map{|d| d.name+"__"+d.status}.join(",")
      if @selected_degree.empty?
        @selected_degree = "__"
      end
      @languages = Language.find(:all)
      @educations = EducationLevel.find(:all)
      @skills = SkillLevel.find(:all)
      @proficiencies = Proficiency.where("activated = ?", 1).all
      render 'credentials', :formats=>[:js], :layout=>false
      return
    when "Basics"
      @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
      @selected_employment_ids  = @job_seeker.job_seeker_desired_employments.map{|j| j.desired_employment_id}
      @selected_location_ids  = @job_seeker.job_seeker_desired_locations.map{|j| j.desired_location_id}
      #@pincode = @job_seeker.job_seeker_desired_locations
      
      #if @pincode[0] != nil
      #    @pincode = @pincode[0].pincode
      #    if @pincode == nil
      #      @pincode = ""
      #    end
      #end
      @location = @job_seeker.job_seeker_desired_locations.first
        
      @compensation_range = $compensation_values
      #@paidtime_range = $desired_paid_time
      #@commute_range = $desired_commute_radius
      @desired_employments = DesiredEmployment.all
      @desired_locations = DesiredLocation.all
      render 'basics', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "hideProfileLoader"
      #        page.replace_html "ajax", :partial=>"/pairing_profile/blocks_basic"
      #      end
      return
    end
  end
  
  def rain_maker
    
  end
  
  def follow_company
    if params[:action_type] == "follow"
      _jsfc_obj = JobSeekerFollowCompany.where("company_id = ? and job_seeker_id = ? ", params[:company_id], session[:job_seeker].id).first
      if _jsfc_obj.blank?
        JobSeekerFollowCompany.create({:company_id => params[:company_id],:job_seeker_id => session[:job_seeker].id})
      end
    else
      JobSeekerFollowCompany.delete_all("company_id = #{params[:company_id]} and job_seeker_id = #{session[:job_seeker].id}")
    end
    render :text => Job.following_jobs(session[:job_seeker].id, session[:job_seeker].ics_type_id, session[:job_seeker].company_id, true).size
  end
  
  def watchlist
    if params[:action_type] == "add"
      _jsfc_obj = JobSeekerWatchlist.where("job_id = ? and job_seeker_id = ? ",params[:job_id],session[:job_seeker].id).first

      if _jsfc_obj.blank?
        JobSeekerWatchlist.create({:job_id => params[:job_id],:job_seeker_id => session[:job_seeker].id})
      end
    else
      JobSeekerWatchlist.delete_all("job_id = #{params[:job_id]} and job_seeker_id = #{session[:job_seeker].id}")
    end
    render :text => Job.watchlist_jobs(session[:job_seeker].id, session[:job_seeker].ics_type_id, session[:job_seeker].company_id, true).size
  end
  
  def detail_comparison
    if session[:job_seeker].ics_type_id == 4
      @job = Job.select("jobs.*, pairing_logics.pairing_value as pairing").joins("join pairing_logics on pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id = #{session[:job_seeker].id}").where("internal = #{false} and jobs.id = '#{params[:job_id]}'").first
    else
      @job = Job.select("jobs.*, pairing_logics.pairing_value as pairing").joins("join pairing_logics on pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id = #{session[:job_seeker].id}").where("company_id IN (#{session[:job_seeker].company.subtree_ids.join(',')}) and jobs.id = '#{params[:job_id]}'").first
    end
    if @job.nil? or @job.active == false
      render 'show_job_inactive', :formats=>[:js], :layout=>false
    else
      @job_status = @job.job_status_for_seeker(session[:job_seeker].id)
      if not @job_status.blank?
        @job_status.set_considering(@job.id, session[:job_seeker].id)
        @job_status.save
      else
        @job_status = JobStatus.create({:job_id =>params[:job_id],:job_seeker_id=>session[:job_seeker].id,:considering=>true})
        @job_status.set_considering(@job.id, session[:job_seeker].id)
        @job_status.save
      end
      
      #@job_status = JobStatus.create({:job_id =>params[:job_id],:job_seeker_id=>session[:job_seeker].id,:considering=>true})0
      #@job_status.set_considering()
      #@job_status.save
      
      #job_location = JobLocation.new
      
      @job_seeker = JobSeeker.where("id = ?",session[:job_seeker].id).first
      #if not job.job_location_id.blank?
      @job_location = JobLocation.where("id = ?", @job.job_location_id).first
      #end
      
      #address_str = form_address_str(job_location)
      if not @job_location.nil?
        @address_str, @full_address = cs_form_address_str(@job_location)
      end
      
      @job_status = @job.job_status_for_seeker(@job_seeker.id)
      
      @company = @job.company_for_job()
      
      @following_company_flag = @job_seeker.is_following_company?(@company)
      @watchlist_flag = session[:job_seeker].job_is_in_watchlist?(@job.id)
      
      @desired_emp = @job.desired_employments.collect{|d| d.name}.join(",")
      @job_desired_emp = @desired_emp.split(",")
      
      @job_roles = OccupationData.find_by_sql("SELECT `occupation_data`.`title` as `title` FROM `occupation_data` INNER JOIN `added_roles` ON `occupation_data`.`onetsoc_code` = `added_roles`.`code` WHERE `added_roles`.`adder_id` = #{@job.id} AND `added_roles`.`adder_type` = 'JobPosition' ORDER BY `added_roles`.`id`")

      @language_skills = @job.language_skill_proficiency

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

      @job_seeker_birkman_detail = @job_seeker.job_seeker_birkman_detail
      
      log_shared_job_traffic_hilo(@job.id)
      if session[:track_channel_hilo] or session[:track_channel_detail_hilo]
        session[:track_channel_hilo] = nil
        session[:track_channel_detail_hilo] = nil
      else
        log_channel_mangaer_hilo(@job.id, SHARE_PLATFORM_HILO_ID)
      end
      render 'detailed_show', :formats=>[:js], :layout=>false
      return
      
    end
  end
  
  def show_job
    if session[:job_seeker].ics_type_id == 4
      @job = Job.select("jobs.*, pairing_logics.pairing_value as pairing").joins("join pairing_logics on pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id = #{session[:job_seeker].id}").where("internal = #{false} and jobs.id = '#{params[:job_id]}'").first
    else
      @job = Job.select("jobs.*, pairing_logics.pairing_value as pairing").joins("join pairing_logics on pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id = #{session[:job_seeker].id}").where("company_id IN (#{session[:job_seeker].company.subtree_ids.join(',')}) and jobs.id = '#{params[:job_id]}'").first
    end
    if @job.nil? or @job.active == false or @job.deleted == true or @job.expire_at < Time.now.utc
      render 'show_job_inactive', :formats=>[:js], :layout=>false
    else
      @job_status = @job.job_status_for_seeker(session[:job_seeker].id)
      if not @job_status.blank?
        @job_status.set_read()
        @job_status.save
      else
        @job_status = JobStatus.create({:job_id =>params[:job_id],:job_seeker_id=>session[:job_seeker].id,:read=>true})
        @job_status.set_read()
        @job_status.save
#        BroadcastController.new.delay(:priority => 6).preview_position(@job.id)
        employer = Job.find(@job.id).employer
#        employer.ancestor_ids.each do |emp_id|
#          BroadcastController.new.delay(:priority => 6).xref_preview(emp_id)
#        end
#        BroadcastController.new.delay(:priority => 6).xref_preview(employer.id)


        BroadcastController.new.employer_update(employer.company_id, "candidate_pool", [@job.id])
        BroadcastController.new.employer_update(employer.company_id, "xref", [@job.id], [session[:job_seeker].id])

      end
      log_shared_job_traffic_hilo(@job.id)
      if session[:track_channel_hilo]
        session[:track_channel_detail_hilo] = 1
        session[:track_channel_hilo] = nil
      else
        log_channel_mangaer_hilo(@job.id, SHARE_PLATFORM_HILO_ID)
      end
      @company = @job.company_for_job()
      @following_company_flag = session[:job_seeker].is_following_company?(@company)

      @desired_emp = @job.desired_employments.collect{|d| d.name}.join(", ")
      @watchlist_flag = session[:job_seeker].job_is_in_watchlist?(@job.id)
      @job_location = JobLocation.where("id = ?", @job.job_location_id).first
      @view_type = "seeker"
      #render :update do |page|

      if @job_status.considering == true
        #page.call "job_detail_view.show",@job.id,""
        render 'job_detail_view_show', :formats=>[:js], :layout=>false
      else
        #page.replace_html "position_overview", :partial =>"/account/preview_popup",:locals=>{:job=>@job, :job_location=>@job_location, :job_status=>@job_status, :company=>@company, :following_company_flag=>@following_company_flag, :view_type=>"seeker", :desired_emp=>desired_emp, :watchlist_flag=>@watchlist_flag}
        render 'position_overview', :formats=>[:js], :layout=>false
      end

      #end
    end
  end
  
  def show_job_for_code
    if session[:job_seeker].ics_type_id == 4
      @job = Job.select("jobs.*, pairing_logics.pairing_value as pairing").joins("join pairing_logics on pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id = #{session[:job_seeker].id}").where("internal = #{false} and code = '#{params[:job_code]}'").first
    else
      @job = Job.select("jobs.*, pairing_logics.pairing_value as pairing").joins("join pairing_logics on pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id = #{session[:job_seeker].id}").where("company_id IN (#{session[:job_seeker].company.subtree_ids.join(',')}) and code = '#{params[:job_code]}'").first
    end
    if not @job.nil?
      if @job.is_active? and @job.has_not_expired? and @job.deleted==false
        @job_status = @job.job_status_for_seeker(session[:job_seeker].id)
        if not @job_status.blank?
          @this_was_not_read = false
          @job_status.set_read()
          @job_status.save
        else
          @this_was_not_read = true
          @job_status = JobStatus.create({:job_id =>@job.id,:job_seeker_id=>session[:job_seeker].id,:read=>true})
          @job_status.set_read()
          @job_status.save
#          BroadcastController.new.delay(:priority => 6).preview_position(@job.id)
          employer = Job.find(@job.id).employer
#          employer.ancestor_ids.each do |emp_id|
#            BroadcastController.new.delay(:priority => 6).xref_preview(emp_id)
#          end
#          BroadcastController.new.delay(:priority => 6).xref_preview(employer.id)

          
          BroadcastController.new.employer_update(employer.company_id, "candidate_pool", [@job.id])
          BroadcastController.new.employer_update(employer.company_id, "xref", [@job.id], [session[:job_seeker].id])
        end
        log_shared_job_traffic_hilo(@job.id)
        @company = @job.company_for_job()
        @following_company_flag = session[:job_seeker].is_following_company?(@company)
        @job_location = JobLocation.where("id = ?", @job.job_location_id).first
        @desired_emp = @job.desired_employments.collect{|d| d.name}.join(", ")
        @watchlist_flag = session[:job_seeker].job_is_in_watchlist?(@job.id)
      else

        render 'career_code_error', :formats=>[:js], :layout=>false
        #        render :update do |page|
        #          if params[:notification]
        #            page.call "show_job.inactive"
        #            page.call "changeCCErrorPopupText"
        #          else
        #            page.call "career_code.show_err_msg"
        #
        #          end
        #        end
        return
      end
    else
      #@job_status = JobStatus.new
      #@company = Company.new
      #@following_company_flag = false
      render 'career_code_error', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        if params[:notification]
      #          page.call "show_job.inactive"
      #          page.call "changeCCErrorPopupText"
      #        else
      #          page.call "career_code.show_err_msg"
      #
      #        end
      #      end
      return
    end

    #    render :update do |page|
    #      if @job_status.considering == true
    #        page.call "career_code.show_details_success_msg"
    #        page.call "job_detail_view.show",@job.id,""
    #      else
    #        page.call "career_code.show_preview_success_msg", @job.id, @this_was_not_read
    #        page.replace_html "position_overview",:partial =>"/account/preview_popup",:locals=>{:job=>@job, :job_location=>@job_location, :job_status=>@job_status, :company=>@company, :following_company_flag=>@following_company_flag, :view_type=>"seeker", :desired_emp=>desired_emp, :watchlist_flag=>@watchlist_flag}
    #        page.call "centralizePopup"
    #      end
    #    end
    render 'career_code_show', :formats=>[:js], :layout=>false
  end
  
  def consider_job
    error = false
    begin
      Job.where(:id=>params[:job_id]).first
    rescue ActiveRecord::RecordNotFound
      error = true
    else
      job_status = JobStatus.where("job_seeker_id = ? and job_id = ?",session[:job_seeker].id,params[:job_id]).first
      job_status = JobStatus.new({:job_seeker_id =>session[:job_seeker].id}) if job_status.blank?
      job_status.job_id = params[:job_id]
      job_status.considering = true
      job_status.save
    end
      
    render :text => error.to_s
    return
  end
    
  def show_interest
    error = false
    begin
      Job.where(:id=>params[:job_id]).first
    rescue ActiveRecord::RecordNotFound
      error = true
    else
      job_status = JobStatus.where("job_seeker_id = ? and job_id = ?",session[:job_seeker].id,params[:job_id]).first
      job_status = JobStatus.new({:job_seeker_id =>session[:job_seeker].id}) if job_status.blank?
      job_status.job_id = params[:job_id]
      job_status.interested = true
      job_status.save
    end
      
    render :text => error.to_s
    return
  end
   
  def wild_card
    error = false
    begin
      Job.where(:id=>params[:job_id]).first
    rescue ActiveRecord::RecordNotFound
      error = true
    else
      job_status = JobStatus.where("job_seeker_id = ? and job_id = ?",session[:job_seeker].id,params[:job_id]).first
      job_status = JobStatus.new({:job_seeker_id =>session[:job_seeker].id}) if job_status.blank?
      job_status.job_id = params[:job_id]
      job_status.wild_card = true
      job_status.save
    end
      
    render :text => error.to_s
    return
  end
  
  def archive_job
    error = false
    begin
      Job.where(:id=>params[:job_id]).first
    rescue ActiveRecord::RecordNotFound
      error = true
    else
      job_status = JobStatus.where("job_seeker_id = ? and job_id = ?",session[:job_seeker].id,params[:job_id]).first
      job_status = JobStatus.new({:job_seeker_id =>session[:job_seeker].id}) if job_status.blank?
      job_status.job_id = params[:job_id]
      job_status.archived = true
      job_status.save
    end
      
    render :text => error.to_s
    return
  end
  
  def pairing_profile
    if params[:show]=="credential"
      session[:open_credential] = true
      redirect_to :controller=>:account,:action=>:pairing_profile
    end
    #@notification_count = JobSeekerNotification.find(:all,:conditions=>["job_seeker_id = ? and visibility = ?",session[:job_seeker].id,true]).size
    @notification_count = JobSeekerNotification.where("job_seeker_id = ? and visibility = ? and new = ?",session[:job_seeker].id, true, true).size
    @job_seeker = JobSeeker.where(:id => session[:job_seeker].id).first
    @job_seeker_languages = JobSeekerLanguage.select("languages.*,job_seeker_languages.*").joins("inner join languages on languages.id = job_seeker_languages.language_id").where("job_seeker_languages.job_seeker_id = ?", @job_seeker.id)
    #@selected_proficiencies = @job_seeker.job_seeker_proficiencies
    @job_seeker_roles = OccupationData.find_by_sql("SELECT `occupation_data`.`title` as `title`, `added_roles`.`education_level_id` as `education_level_id`, `added_roles`.`experience_level_id` as `experience_level_id` FROM `occupation_data` INNER JOIN `added_roles` ON `occupation_data`.`onetsoc_code` = `added_roles`.`code` WHERE `added_roles`.`adder_id` = #{@job_seeker.id} AND `added_roles`.`adder_type` = 'JobSeeker' ORDER BY `added_roles`.`id`")
    @career_clusters = CareerCluster.select("DISTINCT career_cluster")


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
    @job_seeker_certifications = @new_selected_certificates
    @job_seeker_licenses = @new_selected_licenses

  end
  
  def save_pairing_profile_details
    if not request.post?
      redirect_to :controller=>:account,:action=>:pairing_profile
      return
    end
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
       
    #@job_seeker.desired_commute_radius = params[:desired_commute_value]
    #@job_seeker.desired_paid_offs = params[:desired_paidtime_value]
    if params[:pairing_section] == "basic"
      flash[:saved] = "Basics saved"
      @job_seeker.minimum_compensation_amount = params[:compensation_value_min]
      @job_seeker.maximum_compensation_amount = params[:compensation_value_max]
      add_remove_desired_employment()
      add_remove_desired_location()
    else
      flash[:saved] = "Credentials saved"
      @job_seeker.work_exp_value = params[:workexp_value]

      cert_names = params[:certificate_param].blank?  ? [] : params[:certificate_param].split("_jucert_")
      @job_seeker.add_certificates(cert_names,session[:job_seeker].id)
          
      prof_names = params[:proficiency_param].blank?  ? [] : params[:proficiency_param].split("_juprof_")
      @job_seeker.add_proficiencies(prof_names,session[:job_seeker].id)
          
      @job_seeker.add_languages(create_language_hash(params[:selected_languages]))
    end
    if !@job_seeker.job_seeker_birkman_detail.grid_work_environment_x.nil?
      PairingLogic.pairing_value_job_seeker(@job_seeker)
    end
    @job_seeker.save(:validate => false)
    redirect_to :controller=> :account,:action=>:pairing_profile
    return
  end
  
  def get_jobs
    params[:start] ||= 0
    params[:limit] ||= 10
    params[:sort] ||= "fit"
    params[:order] ||= "desc"
    params[:scroll] ||= "false"
    @job_type = params[:job_type]
    case params[:job_type]
    when "inbox"
      @jobs = Job.all_active_posts(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "history"
      @jobs = Job.history_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "employer_view"
      @jobs = Job.employer_viewed_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "following"
      @jobs = Job.following_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "expired"
      @jobs = Job.expired_jobs(session[:job_seeker].id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "considering"
      @jobs = Job.considering_jobs(session[:job_seeker].id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "interested"
      @jobs = Job.interested_jobs(session[:job_seeker].id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "wild_card"
      @jobs = Job.wild_card_jobs(session[:job_seeker].id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "archived"
      @jobs = Job.archived_jobs(session[:job_seeker].id,false,params[:limit],params[:start],params[:sort],params[:order])
    when "dashboard"
      @jobs = Job.top_opportunities(session[:job_seeker].id,false,params[:sort],params[:order])
    when "watchlist"
      @jobs = Job.watchlist_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,false,params[:limit],params[:start],params[:sort],params[:order])
    end
      
    @job_statuses = Job.get_job_status(@jobs,session[:job_seeker].id)
    if session[:job_seeker].ics_type_id == 4
      @jobs_array = Job.where("active = ? AND deleted = ? AND internal = ? AND expire_at > ?", true, false, false, Job.current_date_mysql_format()).count
    else
      @jobs_array = Job.where("active = ? AND jobs.company_id = ? AND deleted = ? AND expire_at > ?", true, session[:job_seeker].company_id, false, Job.current_date_mysql_format()).count
    end

    if params[:scroll]=="false"
      render :partial=>"/account/job_list",:locals=>{:jobs=>@jobs,:job_statuses => @job_statuses}
    else
      render :partial=>"/account/job_list_scroll",:locals=>{:jobs=>@jobs,:job_statuses => @job_statuses}
    end
      
    return
  end
    
  def download_pdf
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    file_name = "#{Rails.root}/#{BIRKMAN_PDF_PATH}/#{session[:job_seeker].id}_birkman_report.pdf"
    send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"Hilo_CFG.pdf"
  end
  
  def request_pdf
    file_name = "#{Rails.root}/#{BIRKMAN_PDF_PATH}/#{session[:job_seeker].id}_birkman_report.pdf"
    result = false
    if File.exists?(file_name)
      result = true
      render 'birkman_report_download', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "birkman_report.download"
      #      end
      return
    else
      render 'birkman_report_pending', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "birkman_report.pending"
      #      end
      return
    end
  end

  def remove_notifications
    @notification = JobSeekerNotification.find(params[:n_id])
    @notification.update_attribute(:visibility,false)
    render :text => "done"
    return
  end

  def fetch_notifications
    params[:start] ||= 0
    params[:limit] ||= 10
    params[:scroll] ||= false
    if params[:start] == 0
      @notifications = JobSeekerNotification.where("job_seeker_id = ? and visibility = ?",session[:job_seeker].id, true).limit("#{params[:limit]}").order("id DESC")
    else
      @notifications = JobSeekerNotification.where("job_seeker_id = ? and visibility = ? and id < ?",session[:job_seeker].id, true, params[:start]).limit("#{params[:limit]}").order("id DESC")
    end
    
    @notifications_old = JobSeekerNotification.where("job_seeker_id = ? and visibility = ?",session[:job_seeker].id, true).order("id DESC")
    
    @notifications_old.each do |n|
      n.new = false
      n.save
    end
    
    if params[:scroll]
      render :partial=>"/account/notification_block_rows", :locals => {:notifications => @notifications}
    else
      render :partial=>"/account/notification_block", :locals => {:notifications => @notifications}
    end 
  end
  
  def fetch_notifications_one_more
    params[:start] ||= 0
    params[:limit] ||= 1
    @notifications = JobSeekerNotification.where("job_seeker_id = ? and visibility = ? and id < ?",session[:job_seeker].id, true, params[:start]).limit("#{params[:limit]}").order("id DESC")
    render :partial=>"/account/notification_block_rows", :locals => {:notifications => @notifications}
  end

  def fetch_notifications_count
    @notifications = JobSeekerNotification.where("job_seeker_id = ? and visibility = ? and new = ?",session[:job_seeker].id, true, true)
    render :text=>@notifications.size
  end

  def time_remaining
    job = Job.find.where("jobs.id = '#{params[:time]}'")
    render :text=>format_remaining_time(job.expire_at)
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
    "<b>#{checktime(q_day)}</b>d <b>#{checktime(q_hr)}</b>h <b>#{checktime(q_min)}</b>m <b>#{checktime(q_sec)}</b>s"
  end

  def checktime i
    str = i.to_s
    if i<10
      str = "0" + str
    end
    return str
  end
  
  def employer_view
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
    @job_seeker_roles = OccupationData.find_by_sql("SELECT `occupation_data`.`title` as `title`, `added_roles`.`education_level_id` as `education_level_id`, `added_roles`.`experience_level_id` as `experience_level_id` FROM `occupation_data` INNER JOIN `added_roles` ON `occupation_data`.`onetsoc_code` = `added_roles`.`code` WHERE `added_roles`.`adder_id` = #{@job_seeker.id} AND `added_roles`.`adder_type` = 'JobSeeker' ORDER BY `added_roles`.`id`")
    @job_seeker_languages = JobSeekerLanguage.select("languages.*,job_seeker_languages.*").joins("inner join languages on languages.id = job_seeker_languages.language_id").where("job_seeker_languages.job_seeker_id = ?", @job_seeker.id)
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
    @job_seeker_certifications = @new_selected_certificates
    @job_seeker_licenses = @new_selected_licenses
    
    render 'employer_view', :format => [:js], :layout => false
    return
  end
  
  def upload_resume
    flag = 0
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
    @job_seeker.attributes = params[:job_seeker]
    if @job_seeker.resume_file_size <= 1048576 and ['application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/msword', 'text/plain'].include?(@job_seeker.resume_content_type)
      @job_seeker.save!(:validate=>false)
      flag = 1
    else
      #session[:upload_failure] = true
    end
    reload_seeker_session(@job_seeker)
    if flag == 1
      responds_to_parent do
        render 'upload_resume', :formats=>[:js], :layout=>false
        #        render :update do |page|
        #          page.call "emptyFormSection"
        #          page.call "showBlockShadow"
        #          page.replace_html "resume-ajax", :partial=>"/account/profile_resume", :locals=>{:job_seeker=>@job_seeker}
        #          page.call "hideBlockShadow"
        #        end
      end
    else
      responds_to_parent do
        render 'upload_resume_error', :formats=>[:js], :layout=>false
        #        render :update do |page|
        #          page.call "emptyFormSection"
        #          page.call "uploadFailureCv"
        #        end
      end
    end
    #redirect_to :controller =>"account",:action =>"pairing_profile"
    return
  end
  
  def upload_photo
    flag = 0
    @job_seeker = JobSeeker.where(:id => session[:job_seeker].id).first
    @job_seeker.attributes = params[:job_seeker]
      
    if @job_seeker.photo_file_size <= 1048576 and (@job_seeker.photo_content_type.split('/')[1] == "jpeg" || @job_seeker.photo_content_type.split('/')[1] == "pjpeg")
      @job_seeker.save!(:validate=>false)
      flag = 1
    else
      #session[:upload_failure] = true
    end
    reload_seeker_session(@job_seeker)
      
    if flag==1
      responds_to_parent do
        render 'upload_photo', :formats => [:js], :layout => false
      end
    else
      responds_to_parent do
        render 'upload_photo_error', :formats => [:js], :layout => false
      end
    end
    return
  end
  
  def delete_resume
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
    @job_seeker.resume_file_name = ""
    @job_seeker.resume_content_type = ""
    @job_seeker.resume_file_size =0
    @job_seeker.save(:validate => false)
    reload_seeker_session(@job_seeker)
    #render :update do |page|
    #page.replace_html "resume-ajax", :partial=>"/account/profile_resume", :locals=>{:job_seeker=>@job_seeker}
    #end
    render :partial=>"/account/profile_resume", :locals=>{:job_seeker=>@job_seeker}
    #redirect_to :controller =>"account",:action =>"pairing_profile"
    return
  end
  
  def delete_photo
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
    @job_seeker.photo_file_name = ""
    @job_seeker.photo_content_type = ""
    @job_seeker.photo_file_size =0
    @job_seeker.save(:validate => false)
    reload_seeker_session(@job_seeker)
      
    #render :update do |page|
    #page.replace_html "resume-ajax", :partial=>"/account/profile_resume", :locals=>{:job_seeker=>@job_seeker}
    #end
    render :partial=>"/account/profile_picture", :locals=>{:job_seeker=>@job_seeker}
    #redirect_to :controller =>"account",:action =>"pairing_profile"
    return
  end
  
  def show_employer_view
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
    render :partial=>"/account/employer_view", :locals => {:job_seeker => @job_seeker, :job_seeker_birkman_detail => @job_seeker.job_seeker_birkman_detail}
  end
  
  def get_job_count_ajax
    count_hash = {:watchlist_count => 0, :new_count => 0, :emp_view_count=>0, :following_count=>0, :expired_count=>0, :all_count=>0, :consider_count=>0, :interest_count =>0, :wild_count=>0, :archived_count => 0}
    count_hash[:emp_view_count] = Job.employer_viewed_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,true).size
    count_hash[:following_count] = Job.following_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,true).size
    count_hash[:watchlist_count]= Job.watchlist_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,true).size
    count_hash[:history_count] = Job.history_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id, true).size
    #count_hash[:new_count] = Job.unread_jobs(session[:job_seeker].id,true).size
    render :text => count_hash[:emp_view_count].to_s+"_"+count_hash[:following_count].to_s+"_"+count_hash[:watchlist_count].to_s+"_"+count_hash[:history_count].to_s
  end

  def seeker_role_for_job
    @job = Job.where(:id=>params[:id].to_i).first
    if params[:seeker_id]
      if params[:seeker_id] == "not_defined"
        @career_seeker = "nil"
        x_score,y_score = @job.work_env_score
        @emp_workenv_text = WorkenvQuestion.text_by_score(x_score,y_score)

        x_score,y_score = @job.role_score
        @emp_role_text = RoleQuestion.text_by_score(x_score,y_score )
      else
        @job_seeker = JobSeeker.where(:id=>params[:seeker_id].to_i).first
        @job_seeker_birkman_detail = @job_seeker.job_seeker_birkman_detail
      end
    else
      @job_seeker_birkman_detail = session[:job_seeker].job_seeker_birkman_detail
    end
    render 'seeker_role_for_job', :formats=>[:js], :layout => false
    return
  end

  def seeker_workenv_for_job
    @job = Job.where("id=?", params[:id].to_i).first
    if params[:seeker_id]
      if params[:seeker_id] == "not_defined"
        @career_seeker = "nil"
        x_score,y_score = @job.work_env_score
        @emp_workenv_text = WorkenvQuestion.text_by_score(x_score,y_score)

        x_score,y_score = @job.role_score
        @emp_role_text = RoleQuestion.text_by_score(x_score,y_score)
      else
        @job_seeker = JobSeeker.find_by_id(params[:seeker_id].to_i)
        @job_seeker_birkman_detail = @job_seeker.job_seeker_birkman_detail
      end
    else
      @job_seeker_birkman_detail = session[:job_seeker].job_seeker_birkman_detail
    end
    render 'seeker_workenv_for_job', :formats=>[:js], :layout => false
    return
  end

  def seeker_role_employer_view
    @job_seeker = JobSeeker.where("id=?",session[:job_seeker].id).first
    render 'seeker_role_employer_view', :formats => [:js], :layout => false
    return
  end

  def seeker_workenv_employer_view
    @job_seeker = JobSeeker.where("id=?",session[:job_seeker].id).first
    render 'seeker_workenv_employer_view', :formats => [:js], :layout => false
    return
  end
  
  private
  
  def get_job_count
    count_hash = {:watchlist_count => 0, :new_count => 0, :emp_view_count=>0, :following_count=>0, :expired_count=>0, :all_count=>0, :consider_count=>0, :interest_count =>0, :wild_count=>0, :archived_count => 0}
    count_hash[:emp_view_count] = Job.employer_viewed_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,true).size
    count_hash[:following_count] = Job.following_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,true).size
    count_hash[:watchlist_count]=Job.watchlist_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,true).size
    count_hash[:history_count] = Job.history_jobs(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id, true).size
    
    #--- Counts not in use ---#
    #count_hash[:new_count] = Job.unread_jobs(session[:job_seeker].id,true).size
    #count_hash[:expired_count] = Job.expired_jobs(session[:job_seeker].id,true).size
    #count_hash[:all_count] = Job.all_active_posts(session[:job_seeker].id,session[:job_seeker].ics_type_id,session[:job_seeker].company_id,true).size
    #count_hash[:consider_count] = Job.considering_jobs(session[:job_seeker].id,true).size
    #count_hash[:interest_count] = Job.interested_jobs(session[:job_seeker].id,true).size
    #count_hash[:wild_count] = Job.wild_card_jobs(session[:job_seeker].id,true).size
    #count_hash[:archived_count] = Job.archived_jobs(session[:job_seeker].id,true).size
    #count_hash[:total_interest_count] = count_hash[:interest_count] + count_hash[:wild_count]

    return count_hash
  end
  
  def determine_layout
    return "registration"
  end

  def fetch_all_roles_for_logged_in_seeker
    @job_seeker_added_roles = AddedRole.where("adder_id = ? AND adder_type = ?", @job_seeker.id, "JobSeeker")
    if !@job_seeker_added_roles[0].nil?
      @career_cluster_role1 = CareerCluster.where("code = ?", @job_seeker_added_roles[0].code).first
    end
    if !@job_seeker_added_roles[1].nil?
      @career_cluster_role2 = CareerCluster.where("code = ?", @job_seeker_added_roles[1].code).first
    end
    if !@job_seeker_added_roles[2].nil?
      @career_cluster_role3 = CareerCluster.where("code = ?", @job_seeker_added_roles[2].code).first
    end
  end
end
