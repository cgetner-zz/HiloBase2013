# coding: UTF-8

class MyIntroductionController < ApplicationController
  layout :determine_layout

  def index
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
  end
  
  def preview
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
  end
  
  def upload_photo
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
      @job_seeker.attributes = params[:job_seeker]
      @job_seeker.save
      redirect_to :controller => "my_introduction",:action =>"index"
      return
  end
  
  def video_url
       @job_seeker = JobSeeker.find(session[:job_seeker].id)
  end
    
  def save_video_url
      #@job_seeker = JobSeeker.find(session[:job_seeker].id)
      #@job_seeker.video_url = params[:video_url]
      render :update do |page|
        page.call "persistValues", params[:video_url]
      end
      return
  end
  
  def edit_summary
        @job_seeker = JobSeeker.find(session[:job_seeker].id)
  end
    
  def save_summary
            @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
            @job_seeker.summary = params[:summary].strip
            if @job_seeker.summary == "Use this space for a short professional introduction."
              @job_seeker.summary = nil
            end
            @job_seeker.armed_forces = params[:armed_forces]
            
            @job_seeker.save(:validate => false)
            reload_seeker_session(@job_seeker)
            render :text=>"Done"
            return
  end
  
  def save_online_presence
            @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
            
            if params[:website_1] != params[:website_placeholder]
              @job_seeker.website_one = params[:website_1]
              @job_seeker.website_one = @job_seeker.website_one.split("//")
              if not (@job_seeker.website_one[0] == "http:" or @job_seeker.website_one[0] == "https:")
                @job_seeker.website_one = "http://"+params[:website_1]
              else
                @job_seeker.website_one = params[:website_1]
              end
            else
              @job_seeker.website_one = nil
            end
            
            if params[:website_2] != params[:website_placeholder]
              @job_seeker.website_two = params[:website_2]
              @job_seeker.website_two = @job_seeker.website_two.split("//")
              if not (@job_seeker.website_two[0] == "http:" or @job_seeker.website_two[0] == "https:")
                @job_seeker.website_two = "http://"+params[:website_2]
              else
                @job_seeker.website_two = params[:website_2]
              end
            else
              @job_seeker.website_two = nil
            end
            
            if params[:website_3] != params[:website_placeholder]
              @job_seeker.website_three = params[:website_3]
              @job_seeker.website_three = @job_seeker.website_three.split("//")
              if not (@job_seeker.website_three[0] == "http:" or @job_seeker.website_three[0] == "https:")
                @job_seeker.website_three = "http://"+params[:website_3]
              else
                @job_seeker.website_three = params[:website_3]
              end
            else
              @job_seeker.website_three = nil
            end
            
            if params[:website_title_1] != params[:website_title_placeholder]
              @job_seeker.website_title_one = params[:website_title_1] 
            else
              @job_seeker.website_title_one = nil
            end
            if params[:website_title_2] != params[:website_title_placeholder]
              @job_seeker.website_title_two = params[:website_title_2] 
            else
              @job_seeker.website_title_two = nil
            end
            if params[:website_title_3] != params[:website_title_placeholder]
              @job_seeker.website_title_three = params[:website_title_3] 
            else
              @job_seeker.website_title_three = nil
            end
            
            @job_seeker.save(:validate => false)
            reload_seeker_session(@job_seeker)
            render :text=>"Done"
            return
  end
  
  def new_resume
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
  end
  
  def upload_resume
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
      @job_seeker.attributes = params[:job_seeker]
      @job_seeker.save
      redirect_to :controller =>"my_introduction",:action =>"index"
      return
  end
  
  def delete_resume
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
      @job_seeker.resume_file_name = ""
      @job_seeker.resume_content_type = ""
      @job_seeker.resume_file_size =0
      @job_seeker.save(:validate => false)
      redirect_to :controller =>"my_introduction",:action =>"index"
      return
  end
  
  
  def delete_photo
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
      @job_seeker.photo_file_name = ""
      @job_seeker.photo_content_type = ""
      @job_seeker.photo_file_size = 0
      @job_seeker.save(:validate => false)
      redirect_to :controller =>"my_introduction",:action =>"index"
      return
  end
  
  def open_contact_info
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
      
  end
  
  def edit_contact_info
      @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
      @job_seeker.phone_one = params[:phone_one]
      if @job_seeker.phone_one == "Telephone"
        @job_seeker.phone_one = nil
      end
      @job_seeker.area_code = params[:area_code]
      if @job_seeker.area_code == "(Area Code)"
        @job_seeker.area_code = nil
      end

      #@job_seeker.phone_two = params[:phone_two]
      @job_seeker.contact_email = params[:contact_email]
      if @job_seeker.contact_email == "Contact Email"
        @job_seeker.contact_email = nil
      end
      
      if not params[:preferred_contact_phone].blank? and not @job_seeker.phone_one.blank? and not @job_seeker.area_code.blank? 
        @job_seeker.preferred_contact = "phone_one"
      elsif not params[:preferred_contact_email].blank? and not @job_seeker.contact_email.blank?
        @job_seeker.preferred_contact = "contact_email"
      else
        @job_seeker.preferred_contact = nil
      end
      
      if @job_seeker.save(:validate => false)
          reload_seeker_session() 
          render :text => "DONE"
      else
            #@job_seeker.errors.each{|k,v|
            #}
          render :text => "ERROR"
          
      end
  end
  
  private
  
  def determine_layout
      case action_name
          when "index"
            return "application"
          when "preview"
            return "preview"
          when "add_links" ,"save_links" 
            return false
          else
            return "iframe"  
      end
  end
  
end

