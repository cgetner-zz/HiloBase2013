# coding: UTF-8

class HomeController < ApplicationController

  layout :determine_layout
  before_filter :destroy_not_logged_search_sessions, :only => [:index]

  def index
    session[:bridge_response] = nil
    session[:track_shared_job_id] = nil
    session[:track_shared_company_id] = nil
    session[:job_not_active] = nil
    session[:company_not_active] = nil
    if params[:forgot_pass]
      @invalid_code = true
      check_reset_code
    else
      if session[:gift_express].nil?
        if session[:job_seeker]
          redirect_to(:controller=>:job_seeker, :action => :new)
        elsif session[:employer]
          redirect_to(:controller=>:employer, :action => :new)
        end
      end
    end
  end

  def career_seeker_bridge
    clear_session_on_logout
    render :layout => "landing_page", :file => "/home/index"
  end

  def download_pdf
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    if params[:id] == "1"
      file_name = "#{Rails.root}/public/HiloforRedeployment.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"HiloforRedeployment.pdf"
    elsif params[:id] == "2"
      file_name = "#{Rails.root}/public/QuantitativeOutplacement.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"QuantitativeOutplacement.pdf"
    elsif params[:id] == "3"
      file_name = "#{Rails.root}/public/TheCaseforReplacingJobBoards.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"TheCaseforReplacingJobBoards.pdf"
    elsif params[:id] == "4"
      file_name = "#{Rails.root}/public/Sample-Career-Foward-Guide.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"Sample-Career-Foward-Guide.pdf"
    elsif params[:id] == "5"
      file_name = "#{Rails.root}/public/NewReality2012.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"NewReality2012.pdf"
    end
  end

  def share_login
    @job_seeker = JobSeeker.authenticate_job_seeker(params[:login_name],params[:login_pass])
    if not @job_seeker.blank?
      reload_seeker_session(@job_seeker)
      log_shared_job_traffic()
      log_channel_manager()
      render :update do |page|
        page.redirect_to :controller => "account",:action => "index"
      end
    else
      render :update do |page|
        page.call "shareLoginError"
      end
    end
  end

  def clear_gift_session
    if session[:employer] or session[:job_seeker]
      session[:employer] = nil
      session[:job_seeker] = nil
    end
    render :text => "Done"
  end

  def show_checkout_billing
    render 'show_checkout_billing', :format => [:js], :layout => false
    return
  end

  def show_success_msg
    render 'show_success_msg', :format => [:js], :layout => false
    return
  end

  def checkout_billing_close
    render 'checkout_billing_close', :format => [:js], :layout => false
    return
  end

  def credit_card_show
    render 'credit_card_show', :formats => [:js], :layout => false
    return
  end

  def check_login_not_success
    render 'check_login_not_success', :formats => [:js], :layout => false
    return
  end

  def purchase_review
    if !session[:job_seeker].nil? and !session[:job_seeker].credit.nil?
      reload_seeker_session
      @credit_value = session[:job_seeker].credit.credit_value
    else
      @credit_value = nil
    end
    render 'purchase_review', :format => [:js], :layout => false
    return
  end
  
  def closeSharing
    session[:track_shared_job_id] = nil
    render :text => "Done"
  end
 
  def job_seeker_learn 
  end
  
  def employer_learn
  end
  
  def privacy
  end
  
  def print_privacy
  end
  
  def t_and_c
  end
  
  def print_tandc
  end
 
  def send_fb_stream
    user_fb = facebook_session.user
    user_fb.publish_to(
      user_fb, 
      :message => "The Hilo Project",
      :attachment => 
        {
        :name  => "Hilo brings Career Seekers and Employers together using a highly interactive
                                          pairing system that not only takes into consideration traditional criteria such as
                                          credentials but personality and work environment fit too. Explore the Hilo Project
                                          and discover the tools you need to find the career you've always wanted.",
        :href  => "https://thehiloproject.com",
        :media => 
          [{
            :type => "image",
            :src  => "https://thehiloproject.com/assets/hilo_logo.png",
            :href => "https://thehiloproject.com"
          }]
      },
      :action_links => 
        [{
          :text => 'www.thehiloproject.com',
          :href => 'https://thehiloproject.com'
        }]
    )  
    render :text => "success"    
  end

  def credit_card_popup
    if not session[:job_seeker].nil? and not session[:job_seeker].credit.nil?
      reload_seeker_session
      @credit_value = session[:job_seeker].credit.credit_value
    else
      @credit_value = nil
    end
    render(:partial => "/home/credit_card_popup", :locals => {:promo_consumed_amount => nil, :remianing_amount => nil})
    return
  end
  
  private
  
  def determine_layout
    case action_name
    when "privacy","t_and_c","print_tandc","print_privacy"
      return false
    when "index"
			return "landing_page"
    else
      return "application"
    end
  end

  #TODO : Remove either of the 2 methods  keep DRY
  def check_reset_code
    @job_seeker = JobSeeker.where("fpwd_code = ?",params[:forgot_pass].to_s.strip).first
    if not @job_seeker.blank?
      @invalid_code = false
    else
      @employer = Employer.where("fpwd_code = ?",params[:forgot_pass].to_s.strip).first
      if not @employer.blank?
        @invalid_code = false
      end
    end
  end

end