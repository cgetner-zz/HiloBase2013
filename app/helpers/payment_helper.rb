# coding: UTF-8

module PaymentHelper
  
  def show_enter_hilo_button
      return (session[:job_seeker].completed_registration_step.to_i == PAYMENT_STEP.to_i) ? true : false
  end

end
