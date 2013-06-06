# coding: UTF-8

class JobPaymentController < ApplicationController
  layout false

  before_filter :job_seeker_with_complete_registration
  before_filter :empty_all_payment_sessions, :only=>[:index]
  before_filter :check_ics_authorization, :only=>[:check_job_expiry, :authenticate_one_click, :credit_card_payment]
  
  def index
    reload_seeker_session
    @job = Job.where("id = ?", params[:job_id]).first
    session[:pay_job] = @job
    @company = @job.company_for_job
    @payment = Payment.new
    @old_payment_obj, @promo_code_obj = Payment.job_seeker_old_payment_obj(session[:job_seeker].id, false)
    session[:old_payment] = @old_payment_obj
    session[:promo_code_obj] = @promo_code_obj
    
    session[:pay_for] = params[:pay_for]

    total_amount = JobStatus.cost_for_purpose(session[:pay_for])

    if not session[:job_seeker].credit.nil?
      credit_value = session[:job_seeker].credit.credit_value
    else
      credit_value = nil
    end

    @total = total_amount
    @credit = credit_value

    logger.info("*************session[:job_seeker].credit #{session[:job_seeker].credit.inspect}")
    logger.info("*********session[:old_payment].nil? #{session[:old_payment].nil?} and credit_value #{credit_value}")
    
    if session[:old_payment].nil? and (credit_value.nil? or credit_value == 0)
      render 'credit_card_payment', :formats=>[:js], :layout=>false
      return
    elsif !session[:old_payment].nil? and (credit_value.nil? or credit_value == 0)
      if not session[:one_click_card].nil?
        logger.info("*****************Time.now - session[:one_click_card][:time] #{Time.now - session[:one_click_card][:time]}")
        if Time.now - session[:one_click_card][:time] <= PAYMENT_SESSION_TIMER
          render 'authenticate_one_click_session_exist', :formats => [:js]
        else
          session[:one_click_card] = nil
          render 'click_payment_one_click_payment_credit', :formats=>[:js]
        end
      else
        render 'click_payment_one_click_payment_credit', :formats=>[:js]
      end
      return
    elsif !credit_value.nil? and credit_value >= total_amount
      if not session[:old_payment].nil?
        session[:old_payment].card_type = "promo"
      end
      if not session[:one_click_card].nil?
        if Time.now - session[:one_click_card][:time] <= PAYMENT_SESSION_TIMER
          render 'authenticate_one_click_session_exist', :formats => [:js]
        else
          session[:one_click_card] = nil
          render 'click_payment_one_click_payment', :formats=>[:js]
        end
      else
        render 'click_payment_one_click_payment', :formats=>[:js]
      end
      return
    elsif !credit_value.nil? and credit_value < total_amount
      if not session[:one_click_card].nil?
        if Time.now - session[:one_click_card][:time] <= PAYMENT_SESSION_TIMER
          render 'authenticate_one_click_session_exist', :formats => [:js]
        else
          session[:one_click_card] = nil
          render 'click_payment_one_click_payment', :formats=>[:js]
        end
      else
        render 'click_payment_one_click_payment', :formats=>[:js]
      end
      return
    end

    #    if !@promo_code_obj.nil?
    #      if @promo_code_obj.amount - @promo_code_obj.consumed_amount >= JobStatus.cost_for_purpose(session[:pay_for])
    #        render 'click_payment_one_click_payment', :formats=>[:js]
    #        return
    #      else
    #        render 'click_payment_credit_card_payment', :formats=>[:js], :layout=>false
    #        return
    #      end
    #    elsif !@old_payment_obj.nil?
    #      render 'click_payment_one_click_payment_credit', :formats=>[:js]
    #      return
    #    else
    #      render 'credit_card_payment', :formats=>[:js]
    #      return
    #    end

  end

  def complete_purchase_no_one_click
    @total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    if not session[:job_seeker].credit.nil?
      @credit_value = session[:job_seeker].credit.credit_value
    end
    render 'click_payment_credit_card_payment', :formats=>[:js], :layout=>false
    return
  end

  def complete_purchase_one_click
    @total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    if not session[:job_seeker].credit.nil?
      @credit_value = session[:job_seeker].credit.credit_value
    end
    render 'complete_purchase_one_click', :formats=>[:js], :layout=>false
    return
  end

  def exclude_payment
    @job_id = params[:job_id]
    @pay_for = params[:pay_for]
    payment = Payment.new()
    payment.job_seeker_id = session[:job_seeker].id
    payment.job_id = params[:job_id]
    if params[:pay_for] == "interest_excluded"
      payment.payment_purpose = "job_interest_excluded"
    elsif params[:pay_for] == "wild_excluded"
      payment.payment_purpose = "job_wild_excluded"
    elsif params[:pay_for] == "consider_excluded"
      payment.payment_purpose = "job_consider_excluded"
    end
    payment.save(:validate => false)

    JobStatus.change_job_status(params[:job_id], session[:job_seeker].id, params[:pay_for])

    render 'exclude_payment', :formats => [:js], :layout => false
  end

  def authenticate_one_click
    @job_seeker_authenticate = JobSeeker.authenticate_job_seeker(params[:pay_name],params[:pay_pass])
    @total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    if not session[:job_seeker].credit.nil?
      @credit_value = session[:job_seeker].credit.credit_value
    end
    render 'authenticate_one_click', :formats => [:js], :layout => false
    
  end

  def credit_card_payment
    @temp = paypal_pro_payment(params[:change_payment])
    render 'credit_card_payment_submit', :formats=>[:js], :layout=>false
  end

  def show_credit_card
    render 'credit_card_payment', :formats=>[:js]
    return
  end

  def paypal_payment
    paypal_express_payment(params[:change_payment])
  end
  
  def payment_details
    @resp_case = ""
    if params[:promotional_code].blank? and params[:transaction_type].blank?
      @resp_case = "no_option"
      return
    end
    init_job_view_pay()    
    if params[:transaction_type].blank?
      @resp_case = "message"
      @message = "Select one of the transaction options previous transaction details or make new payment"
      return
    end
           
    if  params[:transaction_type] =="old" and !params[:past_promo_code].blank?
      params[:promotional_code] = params[:past_promo_code]
    end
               
    job_view_charge_amount(params[:pay_for])

    if params[:transaction_type] == "old"
      if !params[:past_promo_code].blank? and (session[:job_view_pay][:total_amount] != session[:job_view_pay][:promotional_code_amount])
        @resp_case = "message"
        @message = "You have only $#{sprintf('%.2f', session[:job_view_pay][:promotional_code_amount])} in your promotional code.<br/>Make new payment to pay $#{sprintf('%.2f', session[:job_view_pay][:total_amount])}."
        return
      else
        @resp_case = "submit_form"
        return
      end
    end

    #section for new transaction payment
    if @error_arr .length > 0
      @resp_case  = "error"
      @error_json = json_from_error_arr(@error_arr )
      return
    end
              
    if params[:payment_type].blank?
      if session[:job_view_pay][:total_amount] == session[:job_view_pay][:promotional_code_amount]
        @resp_case = "submit_form"
        return
      else
        @resp_case = "message"
        @message = "Select one of the payment options Credit Card or Paypal Express Checkout"
        return
      end
    end

    if !params[:payment_type].blank?

      if session[:job_view_pay][:total_amount] == session[:job_view_pay][:promotional_code_amount]
        @resp_case = "confirm"
        @message = "You have sufficient balance in your promotional code.<br/>$#{sprintf('%.2f', session[:job_view_pay][:promotional_code_amount])} will be deducted from your promotional code.<br/>No paypal transaction will be made.<br/>Please click ok to confirm."
        return
      else
        if session[:job_view_pay][:promotional_code_amount].to_f == 0.0
          @resp_case = "submit_form"
          return
        else
          @resp_case = "confirm"
          @message = "You will be charged $#{sprintf('%.2f', session[:job_view_pay][:promotional_code_amount])} from your promotional code and $#{sprintf('%.2f', session[:job_view_pay][:paypal_amount])} from paypal.<br/>Please click ok to confirm."
          return
        end
      end
    end
    @resp_case = "submit_form"
    return
  end
        
  def make_payment
    make_transaction
  end
        
  def confirm_payment
    total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    paypal_amount, promotional_code_amount = promotional_code_amt(total_amount)
    @express_error = false
    if params[:token].blank?
      return
    end
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    details_response = gateway.details_for(params[:token])
    if !details_response.success? 
      @express_error = true
      @message = details_response.message
    else
      @purchase = gateway.purchase(paypal_amount.to_f * 100,  :ip=> get_remote_ip(), :payer_id => params[:PayerID],:token => params[:token])
      if !@purchase.success?
        @express_error = true
        @message = @purchase.message
      else
        after_express_complete_payment(details_response.address,@purchase)
        session[:paypal_job_view] = 1
        redirect_to :controller => :account, :action => :index
        return
      end
    end
    if @express_error == true
      redirect_to :controller =>:account,:action=>:index
      return
    end
  end

  def check_ics_authorization
    if session[:pay_job]
      job = Job.where("id = ?", session[:pay_job].id).first
    else
      job = Job.where("id = ?", params[:job_id].to_i).first
    end
    
    if session[:job_seeker].ics_type_id == 3
      if job.nil?
        clear_session_on_logout
        if request.xhr?
          render '/account/logout_career_seeker', :formats=>[:js], :layout=>false
        else
          redirect_to :controller=>:home,:action=>:index
        end
      end
    else
      if job.nil?
        render 'check_ics_authorization', :formats=>[:js], :layout=>false
      elsif job.internal == true
        if session[:job_seeker].ics_type_id == 4
          render 'check_ics_authorization', :formats=>[:js], :layout=>false
        end
      end
    end
  end

  def check_job_expiry
    job = Job.where("id = ?", params[:job_id].to_i).first
    remaining_days = (job.expire_at - DateTime.now)/(24*60*60)
    remaining_days = remaining_days.days
    remaining_hours = remaining_days / 1.hour
    if remaining_hours < 48
      remaining_hours = remaining_hours.hour
      mm, ss = remaining_hours.divmod(60)
      hh, mm = mm.divmod(60)
      @time_left = "%dh %dm" % [hh, mm]
      render :text => "success_"+@time_left
    else
      render :text => "job_is_valid"
    end
  end
      
  private
         
  def make_transaction
    if session[:job_view_pay][:total_amount] == session[:job_view_pay][:promotional_code_amount]
      pay_all_by_promo_code
    else
      if !params[:transaction_type].blank? and params[:transaction_type][0] == "new"
        if params[:payment_type] == "paypal_express"
          paypal_express_payment
        else
          paypal_pro_payment
        end
      else
        if make_payment_with_old_transaction(session[:job_view_pay][:paypal_amount])
          @resp_case = "payment_success"
        else
          @error_json = json_from_error_arr([["payment_fail","Failed to make transaction"]])
          @resp_case = "error"
        end
      end
    end
  end

  def pay_all_by_hilo
    total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    @job_seeker = JobSeeker.where("id = ?", session[:job_seeker].id)
    @payment = return_payment_obj_for_hilo(total_amount,get_payment_purpose)
    @payment.payment_success = true
    @payment.job_id = session[:pay_job].id
    @payment.job_seeker_id = session[:job_seeker].id
    @payment.save(:validate => false)
    consumed_hilo_credit(total_amount)
    set_job_status
    reload_seeker_session
    if session[:one_click_card].nil?
      session[:one_click_card] = {:time => Time.now()}
    end
  end
  
  def pay_all_by_promo_code
    total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    @job_seeker = JobSeeker.where("id = ?", session[:job_seeker].id)
    @payment = return_payment_obj_for_promo_code(total_amount,session[:promo_code_obj].id,session[:promo_code_obj].amount,get_payment_purpose())
    @payment.payment_success = true
    @payment.job_id = session[:pay_job].id
    @payment.job_seeker_id = session[:job_seeker].id
    @payment.save(:validate => false)
    set_job_status()
    consumed_promotional_code(total_amount)
  end

  def pay_all_by_credit_or_paypal
    total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    if not session[:job_seeker].credit.nil?
      if session[:job_seeker].credit.credit_value > 0
        credit_amount = session[:job_seeker].credit.credit_value
        total_amount = total_amount - credit_amount
      else
        credit_amount = 0.0
      end
    else
      credit_amount = 0.0
    end
    reference_code = session[:old_payment].id_billing_agreement.blank? ? session[:old_payment].id_of_transaction : session[:old_payment].id_billing_agreement
    response = Payment.doDirectPayment(get_remote_ip(),total_amount * 100,reference_code)
    if response.success?
      logger.info("*****************credit_amount #{credit_amount}")
      save_direct_payment_details(response, credit_amount)
      set_job_status
      if session[:one_click_card].nil?
        session[:one_click_card] = {:time => Time.now()}
      end

      if credit_amount > 0
        consumed_hilo_credit(credit_amount)
        reload_seeker_session
      end
      return
    end
  end
      
  def paypal_express_payment(change_payment)    
    total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    if change_payment.blank?
      paypal_amount, promotional_code_amount = promotional_code_amt(total_amount)
    else
      paypal_amount = total_amount
      promotional_code_amount = 0.0
    end
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    setup_response = gateway.setup_purchase(paypal_amount.to_f * 100,
      :ip                => get_remote_ip(),
      :return_url        => url_for(:controller=>:job_payment,:action => 'confirm_payment', :only_path => false),
      :cancel_return_url => url_for(:controller=>:account,:action => :abcd, :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end
      
  def after_express_complete_payment(address,purchase_obj)
    total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    paypal_amount, promotional_code_amount = promotional_code_amt(total_amount)
    if not session[:job_seeker].credit.nil?
      if session[:job_seeker].credit.credit_value > 0
        credit_amount = session[:job_seeker].credit.credit_value
        paypal_amount = total_amount - credit_amount
      else
        credit_amount = 0.0
      end
    else
      credit_amount = 0.0
    end
    @job_seeker = JobSeeker.where("id = ?", session[:job_seeker].id)
    @payment = Payment.new({:amount_charged => total_amount,
        :paypal_amount=> paypal_amount,
        :promotional_code_amount => promotional_code_amount,
        :holder_name => address['name'],:card_type=> "NA",
        :card_num => "NA",
        :cvv => "NA",
        :expiry_date=>"NA",
        :billing_address_one=> address['company'].to_s + address['address1'].to_s,
        :billing_address_two=> address['address2'],
        :billing_city=> address['city'],
        :billing_state=>address['state'],
        :billing_zip=>address['zip'],
        :billing_country=> address['country'],
        :promotional_code_id=> session[:promo_code_obj].nil? ?  "NA" : session[:promo_code_obj].id,
        :discount_amount => 0.0,
        :credit_amount => credit_amount
      })
    @payment.payer_id= params[:PayerID]
    @payment.token_value = params[:token]
            
    @payment.job_seeker_id = session[:job_seeker].id
    @payment.id_of_transaction = purchase_obj.params["transaction_id"]
    @payment.paypal_status = purchase_obj.params["payment_status"]
    @payment.id_billing_agreement = purchase_obj.params["billing_agreement_id"]
                  
    @payment.payment_purpose = get_payment_purpose()
    @payment.payment_mode = return_job_view_payment_mode_csv2(promotional_code_amount,$payment_mode[:express])
    @payment.payment_success = true
    @payment.job_id = session[:pay_job].id
            
    @payment.save(:validate => false)
    set_job_status
    if !session[:promo_code_obj].blank?
      consumed_promotional_code(promotional_code_amount)
    end
    if credit_amount > 0
      consumed_hilo_credit(credit_amount)
      reload_seeker_session
    end
  end
      
  def paypal_pro_payment(change_payment)
    total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    if change_payment.blank?
      paypal_amount, promotional_code_amount = promotional_code_amt(total_amount)
    else
      paypal_amount = total_amount
      promotional_code_amount = 0.0
    end
    if not session[:job_seeker].credit.nil?
      if session[:job_seeker].credit.credit_value > 0
        credit_amount = session[:job_seeker].credit.credit_value
        paypal_amount = total_amount - credit_amount
      else
        credit_amount = 0.0
      end
    else
      credit_amount = 0.0
    end

    holder_name = params[:fname] + " " + params[:lname]
    expiry_date = params[:month] + "/" + params[:year]
    billing_contact = params[:billing_area_code] + "-" + params[:billing_telephone_number]
        
    card_type = params[:card_type]
    @payment =  Payment.new({:amount_charged => total_amount,
        :paypal_amount => paypal_amount,
        :promotional_code_amount => promotional_code_amount,
        :holder_name => holder_name,
        :card_type=> params[:card_type],
        :card_num => params[:card_num],
        :cvv => params[:cvv],
        :expiry_date=>expiry_date,
        :billing_address_one=> params[:billing_address_one],
        :billing_address_two=> params[:billing_address_two],
        :billing_city=> params[:billing_city],
        :billing_state=>params[:billing_state],
        :billing_zip=>params[:billing_zip],
        :billing_country=>'US',
        :billing_contact=> billing_contact,
        :promotional_code_id=> session[:promo_code_obj].nil? ?  "NA" : session[:promo_code_obj].id,
        :discount_amount => 0.0,
        :credit_amount => credit_amount

      })
            
    if !@payment.valid?
              
      @payment.errors.each{|k,v|
        logger.info("**********@payment.errors k #{k} and v #{v}")
        @error_arr  << [k,v]
      }
    end
            
    if @error_arr .length > 0
      @resp_case  = "error"
      @error_json = json_from_error_arr(@error_arr )
      return false
    end
            
    payment_success,payment_error,paypal_verified_object = @payment.make_payment(get_remote_ip())
    logger.info("**********payment_success #{payment_success} and payment_error #{payment_error} and paypal_verified_object #{paypal_verified_object.inspect}")
    if payment_success
      @payment.set_values_after_pro_payment_success(paypal_verified_object,get_payment_purpose,return_job_view_payment_mode_csv2(promotional_code_amount,$payment_mode[:pro]))
      @payment.job_seeker_id = session[:job_seeker].id
      @payment.job_id = session[:pay_job].id
      @payment.save(:validate => false)
      set_job_status
      if credit_amount > 0
        consumed_hilo_credit(credit_amount)
        reload_seeker_session
      end
      return true
    else
      @error_json = "[{'key' : 'payment', 'msg' : '" + payment_error + "'}]"
      return false
    end
  end
      
      
  def make_payment_with_old_transaction(cost)
    response,payment_obj,promo_obj = Payment.payment_with_old_transaction(session[:job_seeker].id,"job_seeker",get_remote_ip(),cost,true)
    if response == false
      return false
    else
      if !promo_obj.blank?
        save_payment_details_with_promocode(payment_obj,promo_obj)
        set_job_status()
        consumed_promotional_code()
      elsif response.success?
        save_direct_payment_details(response,payment_obj)
        set_job_status()
        consumed_promotional_code()
        return true
      else
        return false
      end
    end
          
  end
      
  def save_payment_details_with_promocode(payment_obj,promo_obj)
    hash_obj = {     :amount_charged => session[:job_view_pay][:total_amount],
      :payment_success=>true,
      :billing_address_one=>"NA",
      :billing_address_two=>"NA",
      :billing_city=>"NA",
      :billing_state=>"NA",
      :billing_zip=>"NA",
      :billing_country=>"NA",
      :payment_purpose=>get_payment_purpose(),
      :payment_mode=>$payment_mode[:promo_code],
      :promotional_code_amount => session[:job_view_pay][:total_amount],
      :job_seeker_id => session[:job_seeker].id,
      :job_id => session[:job_view_pay][:job_id],
      :promotional_code_id => session[:job_view_pay][:promotional_code_id]
    }
    _payment = Payment.new(hash_obj)
    _payment.save(:validate => false)
  end
      
  def save_direct_payment_details(response, credit_amount = nil)
    logger.info("*****************credit_amount #{credit_amount}")
    total_amount = JobStatus.cost_for_purpose(session[:pay_for])
    paypal_amount, promotional_code_amount = promotional_code_amt(total_amount)
    if response.params["transaction_type"] == "mercht-pmt"
      hash_obj = {:amount_charged => total_amount,
        :id_of_transaction => response.params["transaction_id"],
        :paypal_status => response.params["payment_status"],
        :payment_success=>true,
        :billing_address_one=>session[:old_payment].billing_address_one,
        :billing_address_two=>session[:old_payment].billing_address_two,
        :billing_city=>session[:old_payment].billing_city,
        :billing_state=>session[:old_payment].billing_state,
        :billing_zip=>session[:old_payment].billing_zip,
        :billing_country=>session[:old_payment].billing_country,
        :payment_purpose=>get_payment_purpose,
        :payment_mode=>return_job_view_payment_mode_csv2(promotional_code_amount,$payment_mode[:ref_transaction]),
        :paypal_amount => response.params["gross_amount"],
        :id_billing_agreement => response.params["billing_agreement_id"],
        :discount_amount => 0.0,
        :credit_amount => credit_amount
      }
    else
      hash_obj = {:amount_charged => total_amount,:paypal_amount => response.params["amount"],:paypal_status => response.params["ack"],:id_of_transaction => response.params["transaction_id"],:payment_success=>true,:billing_address_one=>session[:old_payment].billing_address_one,:billing_address_two=>session[:old_payment].billing_address_two,:billing_city=>session[:old_payment].billing_city,:billing_state=>session[:old_payment].billing_state,:billing_zip=>session[:old_payment].billing_zip,:billing_country=>session[:old_payment].billing_country,:payment_purpose=>get_payment_purpose(),:payment_mode=>$payment_mode[:ref_transaction], :discount_amount => 0.0 ,:credit_amount => credit_amount}
    end
    hash_obj.update({:job_id => session[:pay_job].id ,:promotional_code_id => 'NA',:job_seeker_id => session[:job_seeker].id})
    _payment = Payment.new(hash_obj)
    _payment.save(:validate => false)
  end
    
  def set_job_status
    JobStatus.change_job_status(session[:pay_job].id,session[:job_seeker].id,session[:pay_for])
  end
      
  def consumed_promotional_code(total_amount)
    PromotionalCode.consumed_save(session[:promo_code_obj].id,total_amount,"job_seeker",session[:job_seeker].id)
  end

  def consumed_hilo_credit(total_amount)
    Credit.consumed_save(total_amount, session[:job_seeker].id)
  end
      
  def get_payment_purpose
    case session[:pay_for]
    when "consider"
      return $payment_purpose[:job_detail_view]
    when "interest"
      return $payment_purpose[:job_interest]
    when "wild"
      return $payment_purpose[:job_wild]
    end
  end
      
  def job_view_charge_amount(pay_for)
    session[:job_view_pay][:paypal_amount] = session[:job_view_pay][:total_amount] = JobStatus.cost_for_purpose(pay_for)
    session[:job_view_pay][:promotional_code_amount] =  0.0
    if not params[:promotional_code].blank?
      pc_obj = PromotionalCode.valid_code_for_seeker(params[:promotional_code],session[:job_seeker].id)
      if pc_obj.blank?
        @error_arr  << ["promotional_code","Invalid Promotional Code"]
      else
        session[:job_view_pay][:promotional_code_id] = pc_obj.id
        session[:job_view_pay][:total_amount], session[:job_view_pay][:paypal_amount], session[:job_view_pay][:promotional_code_amount], session[:job_view_pay][:promo_remaining_amt] = pc_obj.amount_after_deduction(session[:job_view_pay][:total_amount])
      end
    end
  end

  def promotional_code_amt(total_amount)
    paypal_amount = total_amount
    promotional_code_amount = 0.0
    if !session[:promo_code_obj].nil?
      if session[:promo_code_obj].amount.to_f > session[:promo_code_obj].consumed_amount.to_f
        if(session[:promo_code_obj].amount.to_f - session[:promo_code_obj].consumed_amount.to_f) >=  total_amount
          paypal_amount = 0.00
          promotional_code_amount = total_amount
        else
          promotional_code_amount = session[:promo_code_obj].amount.to_f - session[:promo_code_obj].consumed_amount.to_f
          paypal_amount = total_amount.to_f - promotional_code_amount.to_f
        end
      end
    end
    return paypal_amount, promotional_code_amount
  end
      
  def init_job_view_pay
    session[:job_view_pay] = {:total_amount=>0.0,:paypal_amount=>0.0,:promotional_code_amount=>0.0,:promo_remaining_amt=>0.0,:pay_for => params[:pay_for],:job_id => params[:job_id]}
  end
      
end