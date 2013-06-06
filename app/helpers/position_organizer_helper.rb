# coding: UTF-8

module PositionOrganizerHelper

  def create_job_code_format(job)
      return  job.code.nil? ? "&#34;<i>To be assigned</i>&#34;" : job.code.to_s
  end
  
  def job_image(obj,num)
      if num == "one"
           if obj.photoone_file_name.blank?
              return "/assets/upload_sample_photo.jpg"
           else
              return obj.photoone.url(:thumb)
           end
      else
           if obj.phototwo_file_name.blank?
              return "/assets/upload_sample_photo.jpg"
           else
              return obj.phototwo.url(:thumb)
           end 
      end
      
  end

  def set_job_expire_val(job)
      str =""
      if not job.expire_at.blank?
          str = job.expire_at.strftime("%Y-%m-%d")
      end
        
      return str
  end
  
  def job_active_status(job)
    return (job.active == true ? true : false)
  end
  
  
  def job_status_image(job)
      str = ""
      #status = job_active_status(job)
      if job.active
        if job.internal
          str = "<img src='/assets/employer/yellow_dot.png' style='margin-left:16px'/>".html_safe.force_encoding('utf-8')
        else
          str = "<img src='/assets/employer/green_dot.png' style='margin-left:16px'/>".html_safe.force_encoding('utf-8')
        end
      else
          str = "<img src='/assets/employer/red_dot.png' style='margin-left:16px'/> ".html_safe.force_encoding('utf-8')
      end
      return str 
  end
  
  def set_hidden_active_value_for_job(job)
          return  job.new_record? ?  0 : job.active
  end
  
  
  def show_update_message_on_load
      if session[:show_job_post_message]
          session[:show_job_post_message]  = nil
          return "eval(\"share_job.success_msg('Job posted on #{session[:share_platform_name]}')\");"
      end
  end
  
  
  def work_color_env_text(image_name)
    str = ""
    if session[:employer]  
          case image_name 
              when "workenv_bottom_left.png"
                  str = "The YELLOW Work Environment"
              when "workenv_bottom_right.png"
                  str = "The BLUE Work Environment"
              when "workenv_top_left.png"
                  str = "The RED Work Environment"
              when "workenv_top_right.png"
                  str = "The GREEN Work Environment"
          end
    else
          str = "Explore opportunities with Work Environments that..."    
    end
    return "<span style='font-weight:bold;font-size:13px;'>#{str}</span>"
  end
  
  def role_color_env_text(image_name)
      str = ""
      if session[:employer]  
          case image_name 
            when "role_bottom_left.png"
                str = "YELLOW Role <i>\"The Counter\"</i>"
            when "role_bottom_right.png"
                str = "BLUE Role <i>\"The Thinker\"</i>"
            when "role_top_left.png"
                str = "RED Role <i>\"The Doer\"</i>"
            when "role_top_right.png"
                str = "GREEN Role <i>\"The Talker\"</i>"
          end
      else
           str = "Explore opportunities with Roles that..."     
      end
      
      return "<span style='font-weight:bold;font-size:13px;'>#{str}</span>"
  end
  
  
  
end
