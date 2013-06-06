# coding: UTF-8

module PositionProfileHelper
  
  def pos_profile_completed_img(job,tab_type)
    cross_icon = "<img src='/assets/cross_button.png'/>"
    tick_icon = "<img src='/assets/check_button.png'/>"
      
    return cross_icon if job.id.blank?
      
    case tab_type
    when 'desc'
      return tick_icon
    when 'basic'
      return job.basic_complete ? tick_icon : cross_icon
    when 'work_env'
      return job.personality_work_complete ? tick_icon : cross_icon
    when 'role'
      return job.personality_role_complete ? tick_icon : cross_icon
    when 'credential'
      return job.credential_complete ? tick_icon : cross_icon
    end
  end
  
  
  def profile_buy_button(job_seeker_id, employer_id, job_id, internal_flag = 0, javascript = 0)
    company_id = session[:employer].company_id
    purchased_profile = PurchasedProfile.seeker_purchased_by_company(job_seeker_id, company_id)
    if purchased_profile.nil?
      return create_buy_link(job_seeker_id, job_id, internal_flag, javascript)
    else
      time_diff = Time.now.utc.to_i - purchased_profile.created_at.to_i
      if time_diff < 0
        return create_buy_link(job_seeker_id, job_id, internal_flag, javascript)
      else
        days_count = (time_diff / (24 * 60 * 60)).floor
        days_left = PURCHASED_PROFILE_VALIDITY - days_count
        if days_left > 0
          if days_left == 1
            if javascript == 0
              return "<a href='javascript:void(0);' onclick='_showSeekerPopup(#{job_seeker_id}, #{job_id}, #{employer_id})' class='profile-days-left'>#{days_left} Day Left</a>".html_safe.force_encoding('utf-8')
            else
              return "_showSeekerPopup(#{job_seeker_id}, #{job_id}, #{employer_id})"
            end
          end
          if javascript == 0
            return "<a href='javascript:void(0);' onclick='_showSeekerPopup(#{job_seeker_id}, #{job_id}, #{employer_id})' class='profile-days-left'>#{days_left} Days Left</a>".html_safe.force_encoding('utf-8')
          else
            return "_showSeekerPopup(#{job_seeker_id}, #{job_id}, #{employer_id})"
          end
        else
          return create_buy_link(job_seeker_id, job_id, internal_flag, javascript)
        end
      end
    end
  end
    
  def create_buy_link(job_seeker_id, job_id, internal_flag, javascript)
    job_seeker = JobSeeker.find_by_id(job_seeker_id)
    job = Job.select("active").where(:id => job_id).first
    if [1,2,3].include?(job_seeker.ics_type_id)
      internal_flag = 1
    end
    if EXCLUDE_PAYMENT != 1
      if session[:employer].company.hilo_subscription
        if internal_flag == 1
          if job.active == false
            if javascript == 0
              return "<a href='javascript:void(0);' onclick='inactive_payment_box(#{job_id});' class='buy-profile-link'>Get Profile</a>".html_safe.force_encoding('utf-8')
            else
              return "inactive_payment_box(#{job_id})"
            end
          else
            if javascript == 0
            return "<a href='javascript:void(0);' onclick='_openOneClickPaymentBox_exclude_payment(#{job_seeker_id}, #{job_id});' class='buy-profile-link'>Get Profile</a>".html_safe.force_encoding('utf-8')
            else
              return "_openOneClickPaymentBox_exclude_payment(#{job_seeker_id}, #{job_id})"
            end
          end
        else
          if job.active == false
            if javascript == 0
              return "<a href='javascript:void(0);' onclick='inactive_payment_box(#{job_id});' class='buy-profile-link'>Buy $#{PURCHASE_PROFILE_COST}</a>".html_safe.force_encoding('utf-8')
            else
              return "inactive_payment_box(#{job_id})"
            end
          else
            if javascript == 0
              return "<a href='javascript:void(0);' onclick='_openOneClickPaymentBox(#{job_seeker_id}, #{job_id});' class='buy-profile-link'>Buy $#{PURCHASE_PROFILE_COST}</a>".html_safe.force_encoding('utf-8')
            else
              return "_openOneClickPaymentBox_exclude_payment(#{job_seeker_id}, #{job_id})"
            end
          end
        end
      else
        if job.active == false
          if javascript == 0
            return "<a href='javascript:void(0);' onclick='inactive_payment_box(#{job_id});' class='buy-profile-link'>Buy $#{PURCHASE_PROFILE_COST}</a>".html_safe.force_encoding('utf-8')
          else
            return "inactive_payment_box(#{job_id})"
          end
        else
          if javascript == 0
            return "<a href='javascript:void(0);' onclick='_openOneClickPaymentBox(#{job_seeker_id}, #{job_id});' class='buy-profile-link'>Buy $#{PURCHASE_PROFILE_COST}</a>".html_safe.force_encoding('utf-8')
          else
            return "_openOneClickPaymentBox(#{job_seeker_id}, #{job_id})"
          end
        end
      end
    else
      if job.active == false
        if javascript == 0
          return "<a href='javascript:void(0);' onclick='inactive_payment_box(#{job_id});' class='buy-profile-link'>Get Profile</a>".html_safe.force_encoding('utf-8')
        else
          return "inactive_payment_box(#{job_id})"
        end
      else
        if javascript == 0
          return "<a href='javascript:void(0);' onclick='_openOneClickPaymentBox_exclude_payment(#{job_seeker_id}, #{job_id});' class='buy-profile-link'>Get Profile</a>".html_safe.force_encoding('utf-8')
        else
          return "_openOneClickPaymentBox_exclude_payment(#{job_seeker_id}, #{job_id})"
        end
      end
    end
  end
  
end
