# coding: UTF-8

module JobSeekerHelper
  
  def checked_payment_mode(mode)
      case mode
          when "pro"
              if !params[:payment_type].blank? and params[:payment_type].include?("paypal_pro")
                  return "checked = 'checked'"
              #~ elsif params[:payment_type].blank?
                  #~ return "checked = 'checked'"
              else
                  return ""
              end
          when "express"
              if !params[:payment_type].blank? and params[:payment_type].include?("paypal_express")
                  return "checked = 'checked'"
              else
                  return ""
              end
      end
  end

end
