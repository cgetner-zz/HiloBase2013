# coding: UTF-8

module GiftHelper

  def show_old_trasaction_option(old_payment_obj)
      if (session[:job_seeker] or session[:employer]) and !old_payment_obj.blank?
          return true
      else
          return false
      end
  end
  
end
