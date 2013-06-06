# coding: UTF-8
class Admin::LoginController < ApplicationController
  layout "landing_page"
  
  def index
    redirect_to :controller=>:home if not session[:administrator].nil?
    clear_session_on_logout
  end
  
  def authenticate_administrator
    administrator = Administrator.find_by_email(params[:login_name])
    if not administrator.nil? and administrator.authenticate(params[:login_pass]) and administrator.active == true
      #Notifier.administrator_login.deliver
      session[:administrator] = administrator
      render 'login_success', :format=>[:js], :layout=>false
    else
      #Notifier.administrator_login_failure.deliver
      render 'login_failure', :format=>[:js], :layout=>false
    end
  end
end