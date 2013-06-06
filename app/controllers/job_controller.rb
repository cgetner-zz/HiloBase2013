# coding: UTF-8

class JobController < ApplicationController
  layout "application"
  def index
    if params[:company_name].blank? or params[:job_name].blank?
      job = Job.find_by_id(params[:job_id])
      company = Company.find_by_id(job.company_id) unless job.nil?
      if !company.nil? and !job.nil?
        job_name = job.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
        company_name = company.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
        redirect_to "/job/#{company_name}/#{job_name}/#{params[:job_id]}/#{params[:platform_id]}"
        return
      end
    end
    clear_employer_session()
    session[:track_shared_company_id] = nil
    begin
      @job = Job.where("id = ? AND jobs.active = ? and jobs.internal = ? AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",params[:job_id],true,false,false).first
      if @job.nil?
        session[:job_not_active] = 1
      else
        platform = SharePlatform.where("id = ? ",params[:platform_id]).first
        if platform.nil?
          session[:job_not_active] = 1
        else
          @desired_emp = @job.desired_employments.collect{|d| d.name}.join(", ")
          @job_location = JobLocation.where("id = ?", @job.job_location_id).first
          #JFS-1398 - To be activated POST BETA
          @active_job_count = Job.where("jobs.active = ? AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false).all.size
          @active_emp_count = Employer.where("activated = 1").all.size
          #END JFS-1398
          session[:sharing_job] = @job
          session[:sharing_platform_id] = platform.id
          session[:track_shared_job_id] = @job.id
          session[:track_shared_platform_id] = platform.id
          session[:track_channel_hilo] = 1
          @platform_id = session[:track_shared_platform_id]
        end
      end
    rescue ActiveRecord::RecordNotFound
      # Job doesn't exist
      session[:job_not_active] = 1
    end
    log_channel_manager
    if session[:job_seeker]
      #save job and platform for tracking
      log_shared_job_traffic
      redirect_to :controller=>:account
      return
    end
    render :layout => "landing_page", :file => "/home/index"
  end

  def capture_user_response_for_bridge
    session[:bridge_response] = params[:response]
    session[:track_shared_job_id] = params[:job_id]
    session[:track_shared_platform_id] = params[:platform_id]
    render :text => "DONE"
  end
end