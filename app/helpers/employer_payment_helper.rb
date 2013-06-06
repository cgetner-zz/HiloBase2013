# coding: UTF-8

module EmployerPaymentHelper

  def show_employer_enter_hilo_button
      return (session[:employer].completed_registration_step.to_i == EMPLOYER_PAYMENT_STEP.to_i) ? true : false
  end
  
end
