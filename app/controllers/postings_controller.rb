# coding: UTF-8

class PostingsController < ApplicationController
  layout "dashboard", :except => [:index, :new]
  require 'bitly'
  layout "emp_channel_manager", :only => [:index, :new] # direct layout was not working on prod
  
  before_filter :clear_xref_session
  before_filter :employer_with_complete_registration
  before_filter :get_left_panel_jobs,:only=>[:index,:new,:hilo_share_task,:facebook_share_task,:twitter_share_task,:linkedin_share_task]
  before_filter :check_employer_job_save_permission
  before_filter :validate_job_for_employer,:only =>[:index,:new]
  before_filter :validate_request,:only =>[:index,:new]
  before_filter :check_for_deleted_users
  before_filter :check_for_suspended_users
  
  #:only => [:hilo_share_task]
  
  def index
    reload_employer_session
    @job = Job.where("id = ? and employer_id IN (#{session[:employer].subtree_ids.join(',')})", params[:id]).first
    
    if @job.nil?
      redirect_to :controller =>:employer_account, :action =>:index
      return
    else
      if @job.profile_complete == false
        redirect_to :controller =>:position_profile, :action =>:new_employer_profile, :id => @job.id
        return
      end
    end

    @channel = @job.channel_manager
    if not @channel.nil?
      
    else
      redirect_to "/postings/new/#{params[:id]}?selected=#{params[:selected]}"
    end
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.select("jobs.name,
      job_seekers.first_name,
      employer_alerts.purpose,
      employer_alerts.job_seeker_id,
      employer_alerts.employer_id,
      employer_alerts.id,
      employer_alerts.created_at AS created_at").joins("
      JOIN jobs ON employer_alerts.job_id = jobs.id
      JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("jobs.employer_id IN (?)
      AND employer_alerts.read = ? AND employer_alerts.new = ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.created_at desc").all.size
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    
    @job_id = params[:id]
    @posting_record = Posting.where("job_id = ?", params[:id]).first 
  end

  def activate_share
    posting = Posting.find(params[:posting_id])
    case params[:sharing_channel]
    when "1"
      posting.twitter_share = true
    when "2"
      posting.facebook_share = true
    when "3"
      posting.linkedin_share = true
    end
    posting.save!

    render :text => "Done"
  end
  
  def new
    reload_employer_session
    child_employers = session[:employer].descendant_ids.push(session[:employer].id)
    @notifications_count = EmployerAlert.select("jobs.name,
      job_seekers.first_name,
      employer_alerts.purpose,
      employer_alerts.job_seeker_id,
      employer_alerts.employer_id,
      employer_alerts.id,
      employer_alerts.created_at AS created_at").joins("
      JOIN jobs ON employer_alerts.job_id = jobs.id
      JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id").where("jobs.employer_id IN (?) AND employer_alerts.read = ? AND
      employer_alerts.new = ? AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ?", child_employers, false, true, "consider", session[:employer].id).group("employer_alerts.id").order("employer_alerts.created_at desc").all.size
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
    @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    
    @job_id = params[:id]
    job_check = @job = Job.where("id = ? and employer_id IN (#{session[:employer].subtree_ids.join(',')})", params[:id]).first
    if(job_check.profile_complete == false)
      redirect_to :controller =>:position_profile, :action =>:new_employer_profile, :id => @job_id
      return
    end

    @posting_record = Posting.where("job_id = ? and employer_id = ?", params[:id], session[:employer].id).first

    if @posting_record.nil?
      @posting_record = Posting.new
      @posting_record.job_id = params[:id]
      @posting_record.hilo_share = false
      @posting_record.facebook_share = false
      @posting_record.linkedin_share = false
      @posting_record.twitter_share = false
      @posting_record.url_share = false
      @posting_record.employer_id = session[:employer].id
      @posting_record.save!
    end
    render :action => :index,:layout => "emp_channel_manager"
  end
  
  def hilo_share_task
    job = Job.where(:id=>params[:id]).first
    posting_record_update = Posting.where("job_id = ? and employer_id = ?", params[:id], session[:employer].id).first

    if not job.nil?
      job_ids = Array.new
      job_ids<<job.id
      # Activate a Job Globally
      if (params[:status] == "false" and job.active == false) or (params[:status] == "false" and job.active == true and job.internal == true)
        if !job.active #red to green
          job.company.path_ids.each do |id|
            BroadcastController.new.delay(:priority => 6).opportunities_internal(id, JobSeeker.where(:company_id => job.company.path_ids, :activated => true).map{|js| js.id})
          end
          js_ids = JobSeeker.where("company_id IN (#{job.company.path_ids.join(',')}) OR company_id IS NULL AND activated = #{true}").map{|js| js.id}
        else #yellow to green
          js_ids = JobSeeker.where(:company_id => nil, :activated => true).map{|js| js.id}
        end
        BroadcastController.new.delay(:priority => 6).opportunities_normal(JobSeeker.where(:company_id => nil, :activated => true).map{|js| js.id})


#        js_ids.each do |id|
#          job.company.path_ids.each do |i|
#            BroadcastController.new.delay(:priority => 6).xref_update(id, i, job_ids)
#          end
#        end
#        BroadcastController.new.delay(:priority => 6).candidate_update(job.id)


        BroadcastController.new.employer_update(session[:employer].company_id, "xref", [job.id], js_ids)
        BroadcastController.new.employer_update(session[:employer].company_id, "candidate_pool", [job.id])
        
        job.active = true
        job.internal = false
        job.expire_at = Time.now + (60 * 24 * 60 * 60)
        job.first_active = Time.now if job.first_active.nil?
        job.save!(:validate=>false)

        if not posting_record_update.nil?
          posting_record_update.hilo_share = true
          posting_record_update.save
        end

        generate_alerts_for_sub_ordinate("job-active", job)

        PairingLogic.delay.pairing_value_job(job, "from_channel_manager")
      # Deactivate a Job
      elsif params[:status] == "true" and job.active == true
        if job.internal #yellow to red
          js_ids = JobSeeker.where(:company_id => job.company.path_ids, :activated => true).map{|js| js.id}
          job.company.path_ids.each do |id|
            BroadcastController.new.delay(:priority => 6).opportunities_internal(id, js_ids)
          end

#          js_ids.each do |id|
#            job.company.path_ids.each do |i|
#              BroadcastController.new.delay(:priority => 6).xref_update(id, i, job_ids)
#            end
#          end

          BroadcastController.new.employer_update(session[:employer].company_id, "xref", [job.id], js_ids)
          
        else #green to red
          job.company.path_ids.each do |id|
            BroadcastController.new.delay(:priority => 6).opportunities_internal(id, JobSeeker.where(:company_id => job.company.path_ids, :activated => true).map{|js| js.id})
          end
          BroadcastController.new.delay(:priority => 6).opportunities_normal(JobSeeker.where(:company_id => nil, :activated => true).map{|js| js.id})
          js_ids = JobSeeker.where("company_id IN (#{job.company.path_ids.join(',')}) OR company_id IS NULL AND activated = #{true}").map{|js| js.id}
          
#          js_ids.each do |id|
#            job.company.path_ids.each do |i|
#              BroadcastController.new.delay(:priority => 6).xref_update(id, i, job_ids)
#            end
#          end

          BroadcastController.new.employer_update(session[:employer].company_id, "xref", [job.id], js_ids)

        end

        job.active = false
        job.internal = false
        job.save!(:validate=>false)

        if not posting_record_update.nil?
          posting_record_update.hilo_share = false
          posting_record_update.facebook_share = false
          posting_record_update.twitter_share = false
          posting_record_update.linkedin_share = false
          posting_record_update.url_share = false
          posting_record_update.save
        end
        job_seeker_ids = JobStatus.select("job_seeker_id, employers.company_id as comp_id").joins("join jobs on jobs.id = job_statuses.job_id join employers on employers.id = jobs.employer_id").where("job_id = #{params[:id]} and (interested = 1 or wild_card = 1)")
        job_seeker_ids.each{|j|
          alert = JobSeekerNotification.create(:job_seeker_id => j.job_seeker_id, :job_id => params[:id], :notification_type_id => 3, :notification_message_id => 13, :visibility => true, :company_id => j.comp_id)
          job_seeker = JobSeeker.where(:id => j.job_seeker_id).first
          if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
            Notifier.email_job_seeker_notifications(job_seeker, alert).deliver
            job_seeker.notification_email_time = DateTime.now
            job_seeker.save(:validate => false)
          end
        }
        generate_alerts_for_sub_ordinate("job-inactive", job)
        # Activate a Job internally
      elsif params[:status] == "internal"
        #feed
        if job.active #green to yellow
          js_ids = JobSeeker.where(:company_id=>nil, :activated => true).map{|js| js.id}
          BroadcastController.new.delay(:priority => 6).opportunities_normal(js_ids)

#          js_ids.each do |id|
#            job.company.path_ids.each do |i|
#              BroadcastController.new.delay(:priority => 6).xref_update(id, i, job_ids)
#            end
#          end
#          BroadcastController.new.delay(:priority => 6).candidate_update(job.id)


          BroadcastController.new.employer_update(session[:employer].company_id, "xref", [job.id], js_ids)
          BroadcastController.new.employer_update(session[:employer].company_id, "candidate_pool", [job.id])

          
        else #red to yellow
          js_ids = JobSeeker.where(:company_id=>job.company.path_ids, :activated => true).map{|js| js.id}
          job.company.path_ids.each do |id|
            BroadcastController.new.delay(:priority => 6).opportunities_internal(id, js_ids)
          end
          
#          js_ids.each do |id|
#            job.company.path_ids.each do |i|
#              BroadcastController.new.delay(:priority => 6).xref_update(id, i, job_ids)
#            end
#          end
#          BroadcastController.new.delay(:priority => 6).candidate_update(job.id)

          BroadcastController.new.employer_update(session[:employer].company_id, "xref", [job.id], js_ids)
          BroadcastController.new.employer_update(session[:employer].company_id, "candidate_pool", [job.id])
          
        end
        #
        job.active = true
        job.internal = true
        job.expire_at = Time.now + (60 * 24 * 60 * 60)
        job.first_active = Time.now if job.first_active.nil?
        job.save!(:validate=>false)
        if not posting_record_update.nil?
          posting_record_update.hilo_share = true
          posting_record_update.save
        end
        generate_alerts_for_sub_ordinate("job-active", job)
        PairingLogic.delay.pairing_value_job(job, "from_channel_manager")
      end
    end
    broadcast_job_feed
    render :text => "Done"
  end
  
  def facebook_share_task
    @posting_record_update = Posting.find(params[:posting_id])
    if @posting_record_update.facebook_share == true
      @posting_record_update.facebook_share = false
    else
      @posting_record_update.facebook_share = true
      @posting_record_update.facebook_count = @posting_record_update.facebook_count + 1
    end
    @posting_record_update.save
    render :text => "done"
  end
  
  def twitter_share_task
    @posting_record_update = Posting.find(params[:posting_id])
    if @posting_record_update.twitter_share == true
      @posting_record_update.twitter_share = false
    else
      @posting_record_update.twitter_share = true
      @posting_record_update.twitter_count = @posting_record_update.twitter_count + 1
    end
    @posting_record_update.save
    render :text => "done"
  end
  
  def linkedin_share_task
    @posting_record_update = Posting.find(params[:posting_id])
    if @posting_record_update.linkedin_share == true
      @posting_record_update.linkedin_share = false
    else
      @posting_record_update.linkedin_share = true
      @posting_record_update.linkedin_count = @posting_record_update.linkedin_count + 1
    end
    @posting_record_update.save
    render :text => "done"
    #render :action => :index
  end
  
  def url_share_task
    @posting_record_update = Posting.find(params[:posting_id])
    if @posting_record_update.url_share == true
      @posting_record_update.url_share = false
    else
      @posting_record_update.url_share = true
      @posting_record_update.url_count = @posting_record_update.url_count + 1
    end
    @posting_record_update.save
    render :text => "done"
    #render :action => :index
  end
  
  def common_share_task
    @posting_record_update = Posting.find(params[:posting_id])
    @posting_record_update.facebook_share = false
    @posting_record_update.twitter_share = false
    @posting_record_update.linkedin_share = false
    @posting_record_update.url_share = false
    @posting_record_update.save
  end
  
  def get_left_panel_jobs
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

  def validate_request
    id = params[:id]
    begin
      @job = Job.find(id)
    rescue
    end
    redirect_to :controller => "employer_account", :action => "index" if (!@job.nil? && @job.deleted)
  end

  def generate_alerts_for_sub_ordinate(action, job)
    if job.employer_id != session[:employer].id
      if action == "job-active"
        EmployerAlert.create!(:job_id => job.id, :purpose => "job-active", :read => false, :employer_id => job.employer_id, :employer_job_activity => session[:employer].id)
      elsif action == "job-inactive"
        EmployerAlert.create!(:job_id => job.id, :purpose => "job-inactive", :read => false, :employer_id => job.employer_id, :employer_job_activity => session[:employer].id)
      end
    end
  end
end