# coding: UTF-8

class AppErrorController < ApplicationController
  def index
    #render :layout => false
    render :file => "#{Rails.root}/public/404.html",  :layout => false
    
  end

  def route
    redirect_to :action => :index
  end
end