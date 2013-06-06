# coding: UTF-8

class ForgotPwdController < ApplicationController
  
  def index
    if request.post?
      @error = send_reset_link
      render 'forgot_password', :formats=>[:js], :layout=>false
    end
  end
    
  def reset_password
    check_reset_code()
  end
    
  #TODO  refactor code , too much code for a simple change password.
  def change_password
    check_reset_code()
    if @invalid_code
      @error_json = json_from_error_arr([["invalid_code","Invalid password reset code"]])
      render 'reset_password_error_msg', :formats =>[:js], :layout => false
      return
    elsif params[:new_password].blank?
      @error_json = json_from_error_arr([["password","Password can not be blank"]])
      render :action => "reset_password"
      return
    end
    #TODO merge if else together , use case switches
    if  !@job_seeker.blank?
      @job_seeker.password = params[:new_password]
      @job_seeker.password_confirmation = params[:confirm_password]
      @job_seeker.fpwd_code = ""
      @job_seeker.password_reset = true
      if  @job_seeker.save
        #flash[:notice] = "Password changed successfully. Please login to confirm."
        render 'reset_password_success_msg', :formats =>[:js], :layout => false
        return
      else
        @job_seeker.errors.each{|k,v|
          @error_arr  << [k,v]
        }
        @error_json = json_from_error_arr(@error_arr )
        render :action => "reset_password"
        return
      end
          
    elsif !@employer.blank?
      @employer.password = params[:new_password]
      @employer.password_confirmation = params[:confirm_password]
      @employer.fpwd_code = ""
      if  @employer.save
        #flash[:notice] = "Password changed successfully. Please login to confirm."
        #redirect_to :controller => "/home/employer_learn"
        render 'reset_password_success_msg', :formats =>[:js], :layout => false
        return
      else
        @employer.errors.each{|k,v|
          @error_arr  << [k,v]
        }
        @error_json = json_from_error_arr(@error_arr )
        render :action => "reset_password"
        return
      end
    end
  
  end
  
  private
  
  #TODO : Remove either of the 2 methods  keep DRY
  def check_reset_code
    @job_seeker = JobSeeker.where("fpwd_code = ?",params[:id].to_s.strip).first
    @invalid_code = true
    if not @job_seeker.blank?
      @invalid_code = false
    else
      @employer = Employer.where("fpwd_code = ?",params[:id].to_s.strip).first
      if not @employer.blank?
        @invalid_code = false
      end
    end
  end
  
  def send_reset_link
    params[:forgot_email]
    js = JobSeeker.where("email = ?", params[:forgot_email].to_s.strip).first
      
    error = true
    if not js.blank?
      error = false
      js.fpwd_code = Digest::SHA1.hexdigest(Time.now.to_i.to_s)
      js.save(:validate => false)
      Notifier.reset_password_link(js.email,js.fpwd_code,request.env["HTTP_HOST"]).deliver
    else
      emp = Employer.find(:first,:conditions => ["email = ? and deleted = false", params[:forgot_email].to_s.strip])
      if not emp.blank?
        error = false
        emp.fpwd_code = Digest::SHA1.hexdigest(Time.now.to_i.to_s)
        emp.save(:validate => false)
        Notifier.reset_password_link(emp.email,emp.fpwd_code,request.env["HTTP_HOST"]).deliver
      end
    end
  
    return error
  end
    
end