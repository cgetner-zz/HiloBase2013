# coding: UTF-8

class GiftController < ApplicationController
  
  layout false

  def gift_hilo_payment
    if not params[:url]
      session[:gift] = nil
      setgiftsession
    end

    session[:gift_url] = params[:url]
    if !params[:username_gift].blank? and !params[:password_gift].blank?
      @job_seeker_authenticate = JobSeeker.authenticate_job_seeker(params[:username_gift],params[:password_gift])
      if @job_seeker_authenticate.blank?
        @employer_authenticate = Employer.authenticate_employer(params[:username_gift],params[:password_gift])
        if @employer_authenticate.blank?
          render 'signin_not_success', :formats => [:js], :layout => false
          return
        else
          reload_employer_session(@employer_authenticate)
          @payment = Payment.new
          @old_payment_obj, @promo_code_obj = Payment.employer_old_payment_obj(session[:employer].id,true)
          session[:promo_code_obj] = @promo_code_obj
          render 'signin_success_employer', :formats => [:js], :layout => false
          return
        end
      else
        reload_seeker_session(@job_seeker_authenticate)
        @payment = Payment.new
        @old_payment_obj, @promo_code_obj = Payment.job_seeker_old_payment_obj(session[:job_seeker].id,false)
        session[:promo_code_obj] = @promo_code_obj

        if !session[:job_seeker].nil? and !session[:job_seeker].credit.nil?
          @credit_value = session[:job_seeker].credit.credit_value
        else
          @credit_value = nil
        end


        render 'signin_success_job_seeker', :formats => [:js], :layout => false
        return
      end
    end
    init_gift_pay
    session[:gift_pay][:paypal_amount] = session[:gift_pay][:total_amount] = GIFT_CARD_AMOUNT
    session[:gift_pay][:promotional_code_amount] =  0.0
    
    if params[:payment_type] == "paypal_express"
      paypal_express_payment
    else
      paypal_pro_payment(params[:credit_card])
    end
    
  end

  def gift_hilo_registered_job_seeker
    if not params[:url]
      session[:gift] = nil
      setgiftsession()
    end
    @payment = Payment.new
    if not session[:job_seeker].blank?
      @old_payment_obj, @promo_code_obj = Payment.job_seeker_old_payment_obj(session[:job_seeker].id,false)
    else
      @old_payment_obj, @promo_code_obj = Payment.employer_old_payment_obj(session[:employer].id,true)
    end
    session[:promo_code_obj] = @promo_code_obj
    session[:old_payment] = @old_payment_obj

    if !session[:job_seeker].nil? and !session[:job_seeker].credit.nil?
      reload_seeker_session
      @credit_value = session[:job_seeker].credit.credit_value
    else
      @credit_value = nil
    end

    render 'gift_hilo_registered_job_seeker', :formats => [:js], :layout => false
    return

    init_gift_pay()
    session[:gift_pay][:paypal_amount] = session[:gift_pay][:total_amount] = GIFT_CARD_AMOUNT
    session[:gift_pay][:promotional_code_amount] =  0.0

    if params[:payment_type] == "paypal_express"
      paypal_express_payment
    else
      paypal_pro_payment(params[:credit_card])
    end
  end

  def express_session_gift_hilo
    session[:gift] = nil
    @gift = Gift.new()
    @gift.sender_name = params[:senders_name_pay]
    @gift.sender_email = params[:senders_email_pay]
    @gift.recipient_name = params[:recievers_name_pay]
    @gift.recipient_email = params[:recievers_email_pay]
    @gift.mail_text = params[:personal_msg_pay]
    session[:gift] = @gift
      
    render :text=>"done"
  end

  def authenticate_one_click
    @job_seeker_authenticate = JobSeeker.authenticate_job_seeker(params[:pay_name],params[:pay_pass])

    if @job_seeker_authenticate.blank?
      if !session[:job_seeker].nil?
        if params[:pay_name] != session[:job_seeker].email
          render 'one_click_login_not_success', :formats => [:js], :layout => false
          return
        end
      end
      @employer_authenticate = Employer.authenticate_employer(params[:pay_name],params[:pay_pass])
      if @employer_authenticate.blank?
        if !session[:employer].nil?
          if params[:pay_name] != session[:employer].email
            render 'one_click_login_not_success', :formats => [:js], :layout => false
            return
          end
        end
        render 'one_click_login_not_success', :formats => [:js], :layout => false
        return
      else
        if !session[:employer].nil?
          if params[:pay_name] != session[:employer].email
            render 'one_click_login_not_success', :formats => [:js], :layout => false
            return
          end
        end
        if params[:purchase_call] == "true"
          cases = params[:pay_method_purchase]
        else
          cases = params[:pay_method]
        end
        case cases
        when "promo"

          response = pay_all_by_promo_code()
          if response == true
            render 'gift_hilo_success_msg', :format => [:js], :layout => false
          elsif response == false
          end
          return

        when "NA"

          response = make_payment_with_old_transaction(GIFT_CARD_AMOUNT)
          if response == true
            render 'gift_hilo_success_msg', :format => [:js], :layout => false
          elsif response == false
          end
          return

        when "master"

          response = make_payment_with_old_transaction(GIFT_CARD_AMOUNT)
          if response == true
            render 'gift_hilo_success_msg', :format => [:js], :layout => false
          elsif response == false
          end
          return

        when "visa"

          response = make_payment_with_old_transaction(GIFT_CARD_AMOUNT)
          if response == true
            render 'gift_hilo_success_msg', :format => [:js], :layout => false
          elsif response == false
          end
          return

        when "american_express"

          response = make_payment_with_old_transaction(GIFT_CARD_AMOUNT)
          if response == true
            render 'gift_hilo_success_msg', :format => [:js], :layout => false
          elsif response == false
          end
          return

        when "discover"

          response = make_payment_with_old_transaction(GIFT_CARD_AMOUNT)
          if response == true
            render 'gift_hilo_success_msg', :format => [:js], :layout => false
          elsif response == false
          end
          return
        end

      end
    else
      @employer_authenticate = Employer.authenticate_employer(params[:pay_name],params[:pay_pass])
      if @employer_authenticate.blank?
        if !session[:employer].nil?
          if params[:pay_name] != session[:employer].email
            render 'one_click_login_not_success', :formats => [:js], :layout => false
            return
          end
        end
      end
      if !session[:job_seeker].nil?
        if params[:pay_name] != session[:job_seeker].email
          render 'one_click_login_not_success', :formats => [:js], :layout => false
          return
        end
      end
      if params[:purchase_call] == "true"
        cases = params[:pay_method_purchase]
      else
        cases = params[:pay_method]
      end
      if not session[:job_seeker].credit.nil?
        reload_seeker_session
        @credit_value = session[:job_seeker].credit.credit_value
      else
        @credit_value = nil
      end
      case cases
      when "promo"
        if @credit_value >= GIFT_CARD_AMOUNT
          response = pay_all_by_hilo
          if response == true
            render 'gift_hilo_success_msg', :format => [:js], :layout => false
          end
        elsif @credit_value < GIFT_CARD_AMOUNT
          @old_payment_obj, @promo_code_obj = Payment.job_seeker_old_payment_obj(session[:job_seeker].id,false)
          render 'partial_payment', :formats=>[:js]
        end
        return
      when "NA", "master", "visa", "american_express", "discover"
        response = make_payment_with_old_transaction(GIFT_CARD_AMOUNT)
        if response == true
          render 'gift_hilo_success_msg', :format => [:js], :layout => false
        elsif response == false
                        
        end
        return
      end
    end
          


  end

  def complete_purchase_one_click
    if not session[:job_seeker].credit.nil?
      @credit_value = session[:job_seeker].credit.credit_value
    end
    response = make_payment_with_old_transaction(GIFT_CARD_AMOUNT-@credit_value,@credit_value)
    if response == true
      consumed_hilo_credit(@credit_value)
      render 'gift_hilo_success_msg', :format => [:js], :layout => false
    end
    return
  end
  
  def show
    @gift = Gift.new
  end
  
  def proceed_to_payment
    session[:gift] = nil
      
    if session[:job_seeker]
      params[:gift][:sender_name] = session[:job_seeker].first_name + " " + session[:job_seeker].last_name
      params[:gift][:sender_email] = session[:job_seeker].email
    end
      
    @gift = Gift.new(params[:gift])
      
    if not validate_gift()
      render :update do |page|
        page.call "gift.err_on_payment",@error_json
      end
      return false
    else
      session[:gift] = @gift
      @payment = Payment.new
      if session[:job_seeker]
        @old_payment_obj, @promo_code_obj = Payment.job_seeker_old_payment_obj(session[:job_seeker].id,false)
      elsif session[:employer]
        @old_payment_obj, @promo_code_obj = Payment.employer_old_payment_obj(session[:employer].id,false)
      end
             
      render :update do |page|
        page.replace_html "gift-container",:partial=>"card_details"
      end
      return false
    end
      
  end
    
  def payment_details
    @resp_case = ""
    if params[:promotional_code].blank? and params[:transaction_type].blank?
      @resp_case = "no_option"
      return
    end
      
    init_gift_pay()
    gift_charge_amount()
      
    if @error_arr .length > 0
      @resp_case  = "error"
      @error_json = json_from_error_arr(@error_arr )
      return
    end
      
    if params[:transaction_type].blank?
      @resp_case = "message"
      @message = "Select one of the transaction options previous transaction details or make new payment"
      return
    end
                
    if params[:promotional_code].blank? and !params[:transaction_type].blank? and params[:transaction_type] == "new" and params[:payment_type].blank?
      @resp_case = "message"
      @message = "Select one of the payment options Credit Card or Express Checkout"
      return
    end
      
    #~ if !params[:promotional_code].blank? and params[:transaction_type].blank?
    #~ if session[:gift_pay][:total_amount] == session[:gift_pay][:promotional_code_amount]
    #~ @resp_case = "submit_form"
    #~ return
    #~ else
    #~ @resp_case = "message"
    #~ @message = "You have $#{sprintf('%.2f', session[:gift_pay][:promotional_code_amount])} in your promotional code.<br/>Select one of the payment options to pay remaining $#{sprintf('%.2f', session[:gift_pay][:paypal_amount])}."
    #~ return
    #~ end
    #~ end
  
      
    #~ if !params[:promotional_code].blank? and !params[:transaction_type].blank?
            
    #~ if session[:gift_pay][:total_amount] == session[:gift_pay][:promotional_code_amount]
    #~ @resp_case = "confirm"
    #~ @message = "You have sufficient balance in your promotional code.<br/>$#{sprintf('%.2f', session[:gift_pay][:promotional_code_amount])} will be deducted from your promotional code.<br/>No paypal transaction will be made.<br/>Please click ok to confirm."
    #~ return
    #~ else
    #~ if params[:payment_type].blank? and params[:transaction_type] == "new"
    #~ @resp_case = "message"
    #~ @message = "Select one of the payment options credit card or express checkout"
    #~ return
    #~ end
                  
    #~ @resp_case = "confirm"
    #~ @message = "You will be charged $#{sprintf('%.2f', session[:gift_pay][:promotional_code_amount])} from your promotional code and $#{sprintf('%.2f', session[:gift_pay][:paypal_amount])} from paypal.<br/>Please click ok to confirm."
    #~ return
    #~ end
    #~ end
       
    @resp_case = "submit_form"
    return
  end
  
  
  
  def make_payment
    make_transaction
  end
  
  
  def confirm_payment
    @express_error = false
    if params[:token].blank?
      redirect_to :controller => 'home'
      return
    end
    paypal_amount, promotional_code_amount = promotional_code_amt(GIFT_CARD_AMOUNT)
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    details_response = gateway.details_for(params[:token])
        
    if !details_response.success?
      @express_error = true
      @message = details_response.message
    else
      purchase = gateway.purchase(paypal_amount.to_f * 100,  :ip=> get_remote_ip(), :payer_id => params[:PayerID],:token => params[:token])
      if !purchase.success?
        @express_error = true
        @message = purchase.message
      else
        after_express_complete_payment(details_response.address,purchase)
        #                   if session[:job_seeker]
        #                        redirect_to :controller =>:account,:action=>:index
        #                        return
        #                   else
        session[:gift_express] = 1
        redirect_to CGI::unescape(session[:gift_url])
        return
        #                   end
                   
      end
    end
        
    if @express_error == true
      session[:payment_complete] = false
      redirect_to :controller =>:account,:action=>:index
      return
    end
  end
  
  
  
  private
  
  def setgiftsession
    @gift = Gift.new()
    @gift.sender_name = params[:senders_name_pay]
    @gift.sender_email = params[:senders_email_pay]
    @gift.recipient_name = params[:recievers_name_pay]
    @gift.recipient_email = params[:recievers_email_pay]
    @gift.mail_text = params[:personal_msg_pay]
    session[:gift] = @gift
  end

    
  def make_transaction
    if session[:gift_pay][:total_amount] == session[:gift_pay][:promotional_code_amount]
      pay_all_by_promo_code()
    else
      if !params[:transaction_type].blank? and params[:transaction_type][0] == "new"
        if params[:payment_type] == "paypal_express"
          paypal_express_payment()
        else
          paypal_pro_payment()
        end
      else
        if make_payment_with_old_transaction(session[:gift_pay][:paypal_amount])
          @resp_case = "payment_success"
        else
          @error_json = json_from_error_arr([["payment_fail","Failed to make transaction"]])
          @resp_case = "error"
        end
      end
    end
  end
   
  def pay_all_by_promo_code
    paypal_amount, promotional_code_amount = promotional_code_amt(GIFT_CARD_AMOUNT)
    @payment = return_payment_obj_for_promo_code(GIFT_CARD_AMOUNT,session[:promo_code_obj].id,GIFT_CARD_AMOUNT,$payment_purpose[:gift])
    @payment.payment_success = true
    if session[:job_seeker]
      @payment.job_seeker_id = session[:job_seeker].id
    elsif session[:employer]
      @payment.employer_id = session[:employer].id
    end
    @payment.save(:validate => false)
    save_gift_obj(@payment.id_of_transaction)
    consumed_promotional_code(promotional_code_amount)
    return true
  end
    
  def pay_all_by_hilo
    total_amount = GIFT_CARD_AMOUNT
    @payment = return_payment_obj_for_hilo(total_amount,$payment_purpose[:gift])
    @payment.payment_success = true
    @payment.job_seeker_id = session[:job_seeker].id
    @payment.save(:validate => false)
    save_gift_obj(@payment.id_of_transaction)
    consumed_hilo_credit(total_amount)
    return true
  end


    
  def paypal_pro_payment(credit_card = nil)
    holder_name = params[:fname_gift] + " " + params[:lname_gift]
    expiry_date = params[:month_gift] + "/" + params[:year_gift]
    billing_contact = params[:billing_area_code_gift] + "-" + params[:billing_telephone_number_gift]
    #paypal_amount, promotional_code_amount = promotional_code_amt(GIFT_CARD_AMOUNT)
    paypal_amount = GIFT_CARD_AMOUNT
    if not session[:job_seeker].nil? and not session[:job_seeker].credit.nil?
      if session[:job_seeker].credit.credit_value > 0
        credit_amount = session[:job_seeker].credit.credit_value
        paypal_amount = GIFT_CARD_AMOUNT - credit_amount
      else
        credit_amount = 0
      end
    else
      credit_amount = 0
    end
    card_type = params[:card_type]
    @payment =  Payment.new({
        :amount_charged => GIFT_CARD_AMOUNT ,
        :paypal_amount =>  paypal_amount,
        :holder_name => holder_name,
        :card_type=> card_type,
        :card_num => params[:card_num_gift],
        :cvv => params[:cvv_gift],
        :expiry_date=> expiry_date,
        :billing_address_one=> params[:billing_address_one_gift],
        :billing_address_two=> params[:billing_address_two_gift],
        :billing_city=> params[:billing_city_gift],
        :billing_state=>params[:billing_state_gift],
        :billing_zip=>params[:billing_zip_gift],
        :billing_contact=> billing_contact,
        :billing_country=>'US',
        :promotional_code_id=> session[:promo_code_obj].nil? ?  "NA" : session[:promo_code_obj].id,
        :credit_amount => credit_amount
      })
            
    if !@payment.valid?
      @payment.errors.each{|k,v|
        @error_arr<< [k,v]
      }
    end
            
            
    payment_success,payment_error,paypal_verified_object = @payment.make_payment(get_remote_ip())
    if payment_success
      @payment.set_values_after_pro_payment_success(paypal_verified_object,$payment_purpose[:gift],return_payment_mode($payment_mode[:pro]))
      if session[:job_seeker]
        @payment.job_seeker_id = session[:job_seeker].id
      elsif session[:employer]
        @payment.employer_id = session[:employer].id
      end
                  
                  
      @payment.save(:validate => false)
      save_gift_obj(@payment.id_of_transaction)

      if session[:job_seeker]
        consumed_hilo_credit(credit_amount) if credit_amount!=0
      end

      if !session[:promo_code_obj].blank?
        consumed_promotional_code(promotional_code_amount)
      end
      render 'gift_hilo_success_msg', :format => [:js], :layout => false
      return true
    else
      if credit_card
        render 'not_suuccess_credit_payment', :format => [:js], :layout => false
        @resp_case  = "error"
        @error_json = "[{'key' : 'payment', 'msg' : '" + payment_error + "'}]"
        return false
      else
        render 'not_suuccess_payment', :format => [:js], :layout => false
        @resp_case  = "error"
        @error_json = "[{'key' : 'payment', 'msg' : '" + payment_error + "'}]"
        return false
      end
                  
    end
  end
      
      
  def paypal_express_payment
    paypal_chargeable_amount = session[:gift_pay][:paypal_amount]
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    setup_response = gateway.setup_purchase(paypal_chargeable_amount.to_f * 100,
      :ip                => get_remote_ip(),
      :return_url        => url_for(:controller=>:gift,:action => 'confirm_payment', :only_path => false),
      :cancel_return_url => url_for(:controller=>:home,:action => :index, :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end
      
      
  def after_express_complete_payment(address,purchase_obj)
    #paypal_amount, promotional_code_amount = promotional_code_amt(GIFT_CARD_AMOUNT)
    paypal_amount = GIFT_CARD_AMOUNT
    if not session[:job_seeker].nil? and not session[:job_seeker].credit.nil?
      if session[:job_seeker].credit.credit_value > 0
        credit_amount = session[:job_seeker].credit.credit_value
        paypal_amount = GIFT_CARD_AMOUNT - credit_amount
      else
        credit_amount = 0
      end
    else
      credit_amount = 0
    end
    @payment = Payment.new({
        :amount_charged => GIFT_CARD_AMOUNT,
        :paypal_amount=> paypal_amount,
        :promotional_code_amount => 0,
        :holder_name => address['name'],
        :card_type=> "NA",
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
        :credit_amount => credit_amount
      })
            
    @payment.payer_id= params[:PayerID]
    @payment.token_value = params[:token]
    if session[:job_seeker]
      @payment.job_seeker_id = session[:job_seeker].id
    elsif session[:employer]
      @payment.employer_id = session[:employer].id
    end
            
    @payment.id_of_transaction = purchase_obj.params["transaction_id"]
    @payment.paypal_status = purchase_obj.params["payment_status"]
    @payment.id_billing_agreement = purchase_obj.params["billing_agreement_id"]
                  
    @payment.payment_purpose = $payment_purpose[:gift]
    @payment.payment_mode = return_payment_mode($payment_mode[:express])
    @payment.payment_success = true
            
    @payment.save(:validate => false)
    save_gift_obj(@payment.id_of_transaction)

    if session[:job_seeker]
      consumed_hilo_credit(credit_amount) if credit_amount!=0
    end
    if !session[:promo_code_obj].blank?
      consumed_promotional_code(promotional_code_amount)
    end
            
  end
          
  def gift_charge_amount
    session[:gift_pay][:paypal_amount] = session[:gift_pay][:total_amount] = GIFT_CARD_AMOUNT
    session[:gift_pay][:promotional_code_amount] =  0.0
            
    if not params[:promotional_code].blank?
      if session[:job_seeker]
        pc_obj = PromotionalCode.valid_code_for_seeker(params[:promotional_code],session[:job_seeker].id)
      elsif session[:employer]
        pc_obj = PromotionalCode.valid_code_for_employer(params[:promotional_code],session[:employer].id)
      else
        pc_obj = PromotionalCode.valid_code_for_seeker(params[:promotional_code])
      end
              
      if pc_obj.blank?
        @error_arr<< ["promotional_code","Invalid Promotional Code"]
      else
        session[:gift_pay][:promotional_code_id] = pc_obj.id
        session[:gift_pay][:total_amount], session[:gift_pay][:paypal_amount], session[:gift_pay][:promotional_code_amount], session[:gift_pay][:promo_remaining_amt] = pc_obj.amount_after_deduction(session[:gift_pay][:total_amount])
      end
    end
  end
    
  def init_gift_pay
    session[:gift_pay] = {:total_amount=>0.0,:paypal_amount=>0.0,:promotional_code_amount=>0.0,:promo_remaining_amt=>0.0}
  end
     
  def consumed_promotional_code(promotional_code_amount)
    if session[:job_seeker]
      PromotionalCode.consumed_save(session[:promo_code_obj].id,promotional_code_amount,"job_seeker",session[:job_seeker].id)
    elsif session[:employer]
      PromotionalCode.consumed_save(session[:promo_code_obj].id,promotional_code_amount,"employer",session[:employer].id)
    else
      PromotionalCode.consumed_save(session[:promo_code_obj].id,promotional_code_amount)
    end
            
  end
      
      
      
  def make_payment_with_old_transaction(cost, credit = nil)
    if session[:job_seeker]
      response,payment_obj = Payment.payment_with_old_transaction(session[:job_seeker].id,"job_seeker",get_remote_ip(),cost,false)
    else
      response,payment_obj = Payment.payment_with_old_transaction(session[:employer].id,"employer",get_remote_ip(),cost,false)
    end
          
    if response == false
      return false
    else
      if response.success?
        new_payment_obj = save_direct_payment_details(response,payment_obj,credit)
        save_gift_obj(new_payment_obj.id_of_transaction)
        #consumed_promotional_code()
        return true
      else
        return false
      end
    end
          
  end
      
  def save_direct_payment_details(response,payment_obj,credit = nil)
    if response.params["transaction_type"] == "mercht-pmt"
                   
      hash_obj = {:amount_charged => GIFT_CARD_AMOUNT,
        :id_of_transaction => response.params["transaction_id"],
        :paypal_status => response.params["payment_status"],
        :payment_success=>true,
        :billing_address_one=>payment_obj.billing_address_one,
        :billing_address_two=>payment_obj.billing_address_two,
        :billing_city=>payment_obj.billing_city,
        :billing_state=>payment_obj.billing_state,
        :billing_zip=>payment_obj.billing_zip,
        :billing_country=>payment_obj.	billing_country,
        :payment_purpose=>$payment_purpose[:gift],
        :payment_mode=>return_payment_mode($payment_mode[:ref_transaction]),
        :paypal_amount => response.params["gross_amount"],
        :id_billing_agreement => response.params["billing_agreement_id"],
        :credit_amount => credit
      }
                   
    else
      hash_obj = {:amount_charged => GIFT_CARD_AMOUNT,
        :paypal_amount => response.params["amount"],
        :paypal_status => response.params["ack"],
        :id_of_transaction => response.params["transaction_id"],
        :payment_success=>true,
        :billing_address_one=>payment_obj.billing_address_one,
        :billing_address_two=>payment_obj.billing_address_two,
        :billing_city=>payment_obj.billing_city,
        :billing_state=>payment_obj.billing_state,
        :billing_zip=>payment_obj.billing_zip,
        :billing_country=>payment_obj.billing_country,
        :payment_purpose=>$payment_purpose[:gift],
        :payment_mode=>return_payment_mode($payment_mode[:ref_transaction]),
        :credit_amount => credit
      }
    end
                  
    if session[:job_seeker]
      hash_obj.update({:job_seeker_id => session[:job_seeker].id})
    elsif session[:employer]
      hash_obj.update({:employer_id => session[:employer].id})
    end
              
    _payment = Payment.new(hash_obj)
    _payment.save(:validate => false)
    return _payment
  end
      
            
  def save_gift_obj(id_transaction)
    _pc_obj = PromotionalCode.create_random_code(GIFT_CARD_AMOUNT,$promo_code_origination[:gift_coupon])
    session[:gift].promotional_code_id = _pc_obj.id
    session[:gift].save(:validate => false)
    Notifier.gift_card_mail(session[:gift],_pc_obj,request.env["HTTP_HOST"]).deliver
    Notifier.gift_card_sender(session[:gift],id_transaction,request.env["HTTP_HOST"]).deliver
    session[:gift] = nil
      
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

  def validate_gift
    if not @gift.valid?
      @gift.errors.each{|k,v|
        @error_arr << [k,v]
      }
      @error_json = json_from_error_arr(@error_arr )
      return false
    else
      return true
    end
  end
  
  def consumed_hilo_credit(total_amount)
    Credit.consumed_save(total_amount, session[:job_seeker].id)
    reload_seeker_session
  end
end

