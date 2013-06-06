# coding: UTF-8

class LoginController < ApplicationController
  #layout false
  
  def login

    @job_seeker = JobSeeker.authenticate_job_seeker(params[:login_name].strip, params[:login_pass])
    @success = false
    @redirection_step = nil
     
    if not @job_seeker.blank?
      @success = true
      session[:last_login] = @job_seeker.last_login
      #@job_seeker.last_login = Time.now
      #@job_seeker.save(:validate => false)
      @job_seeker.update_column(:last_login, Time.now)
      reload_seeker_session(@job_seeker)
      #log_shared_job_traffic()
      if not params[:job_code].blank?
        session[:job_code] = params[:job_code]
      end
      
      @redirection_step = redirect_to_registration_step("login")

      # Check for legacy data...
      case session[:job_seeker].completed_registration_step.to_i
      when PAIRING_BASICS_STEP
        legacy_data_handling
      when  PAIRING_CREDENTIALS_STEP
        legacy_data_handling
      when PAYMENT_STEP
        legacy_data_handling
      end
    end
      
    if @job_seeker.blank?
      @employer = Employer.authenticate_employer(params[:login_name],params[:login_pass])
          
      if not @employer.blank?
        session[:bridge_response] = nil
        session[:track_shared_job_id] = nil
        session[:job_not_active] = nil
        session[:track_shared_company_id] = nil
        session[:company_not_active] = nil
        
        session[:last_login] = @employer.last_login
        @employer.last_login = Time.now
        @employer.save(:validate => false)
        
        @success = true
        reload_employer_session(@employer)
        if @employer.activated == false
          @redirection_step = {:controller => :employer, :action=>:new}
        else
          # Check for legacy data...
          if session[:employer].completed_registration_step.to_i == EMPLOYER_PAYMENT_STEP
            legacy_jobs = Job.where("(deactivated_for_new_credential=0 or deactivated_for_new_credential=1) and employer_id=#{session[:employer].id}").first
            if not legacy_jobs.nil? and legacy_jobs.profile_complete==false and legacy_jobs.deleted==false and legacy_jobs.deactivated_for_new_credential==false
              legacy_jobs.deactivated_for_new_credential = true
              legacy_jobs.save(:validate=>false)
              session[:legacy_data_emp] = legacy_jobs
              @notification_emp = EmployerAlert.where(:job_id => legacy_jobs.id,:purpose =>"legacy").first
              if @notification_emp.nil?
                EmployerAlert.create({:job_id => legacy_jobs.id,:purpose =>"legacy",:read => "false", :employer_id=>legacy_jobs.employer_id})
              end
            end
          end
          @redirection_step = redirect_to_employer_registration_step
        end
      end
    end
    
    if @success
      render 'success', :format=>[:js], :layout=>false
    else
      if params[:new_sing_in] == "1"
        render 'error_sign_in', :format => [:js], :layout => false
      else
        render 'error', :format=>[:js], :layout=>false
      end
    end
  end
  
  def logout
    if session[:employer]
      clear_session_on_logout
      redirect_to root_path
    elsif session[:job_seeker]
      clear_session_on_logout
      redirect_to career_seeker_path
    elsif session[:administrator]
      clear_session_on_logout
      redirect_to admin_root_path
    else
      clear_session_on_logout
      redirect_to root_path
    end
    return
  end

  def email_verify
    begin
      if params[:token]
        email = Base64.decode64(params[:token])
        js = JobSeeker.find_by_email(email)
        if !js.nil?
          if js.ics_type_id == 3
            js.update_attribute(:email_verified, true)
          else
            session[:email_doesnot_exist] = 1
          end
        else
          session[:email_doesnot_exist] = 1
        end
      else
        session[:email_doesnot_exist] = 1
      end
    rescue ActiveRecord::RecordNotFound
      #email does not exist
      session[:email_doesnot_exist] = 1
    end
    render :layout => "landing_page", :file => "/home/index"
  end

  private

  def legacy_data_handling
    roles = AddedRole.where(:adder_id=>@job_seeker.id,:adder_type=>"JobSeeker").first
    degrees = AddedDegree.where(:adder_id=>@job_seeker.id,:adder_type=>"JobSeeker").first
    if roles.nil? or degrees.nil?
      session[:legacy_data_cs] = true
      # Generate Notification for that user if not generated.
      @notification = JobSeekerNotification.where(:job_seeker_id=>@job_seeker.id,:notification_message_id=>9).first
      if @notification.nil?
        @notification = JobSeekerNotification.new
        @notification.job_seeker_id = @job_seeker.id
        @notification.notification_type_id = 1
        @notification.notification_message_id = 9
        @notification.visibility = true
        @notification.save
      end
      
    end
  end
  
end