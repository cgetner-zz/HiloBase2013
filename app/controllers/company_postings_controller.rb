# coding: UTF-8

class CompanyPostingsController < ApplicationController
  layout "application"
  def index
    if params[:company_name].blank?
      company = Company.find_by_id(params[:company_id])
      unless company.nil?
        company_name = company.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
        redirect_to "/company/#{company_name}/#{params[:company_id]}/#{params[:platform_id]}"
        return
      end
    end
    clear_session_on_logout
    session[:company_not_exist] = nil
    session[:track_shared_job_id] = nil
    begin
      @company = Company.find_by_id(params[:company_id])
      if @company.nil?
        session[:company_not_exist] = 1
      else
        platform = SharePlatform.where("id = ? ",params[:platform_id]).first
        if platform.nil?
          session[:company_not_exist] = 1
        else
          @employer_privilege = @company.employer_privileges.last
          #JFS-1398 - To be activated POST BETA
          @active_job_count = Job.where("jobs.active = ? AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false).all.size
          @active_emp_count = Employer.where("activated = 1").all.size
          #END JFS-1398
          #session[:sharing_company] = @company
          session[:sharing_platform_id] = platform.id
          session[:track_shared_company_id] = @company.id
          session[:track_shared_platform_id] = platform.id
          session[:track_channel_hilo] = 1
          session[:bridge_response] = "yes"
          @platform_id = session[:track_shared_platform_id]
        end
      end
    rescue ActiveRecord::RecordNotFound
      # Job doesn't exist
      session[:company_not_exist] = 1
    end
    log_recruiting_manager
    render :layout => "landing_page", :file => "/home/index"
  end

  def activate_share
    posting = CompanyPosting.find_by_company_id(session[:employer].company_id)
    case params[:sharing_channel]
    when "1"
      posting.twitter_flag = true
    when "2"
      posting.facebook_flag = true
    when "3"
      posting.linkedin_flag = true
    end
    posting.save!
    render :text => "Done"
  end

  def capture_sessions
    session[:bridge_response] = params[:response]
    session[:track_shared_company_id] = params[:comp_id]
    session[:track_shared_platform_id] = params[:platform_id]
    render :text=>"done"
  end
  
end