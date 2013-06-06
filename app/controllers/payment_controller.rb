# coding: UTF-8

class PaymentController < ApplicationController
  before_filter :required_loggedin_job_seeker
  before_filter :validate_current_step,:except=>[:payment_complete, :add_credit]

  def index
    @payment = Payment.new
    @job_seeker = JobSeeker.where("id=?", session[:job_seeker].id).first
    @old_payment_obj, @promo_code_obj = Payment.job_seeker_old_payment_obj(session[:job_seeker].id, false)
    
    session[:discount_amount] = session[:credit_amount] = nil
    if @job_seeker.bridge_response == "yes" or @job_seeker.bridge_response == "no"
      if @job_seeker.activated != true
        @job_seeker_privilege = @job_seeker.job_seeker_privilege
        if session[:job_seeker].ics_type_id == 3
          session[:discount_amount] =  19.99
          session[:credit_amount] =  0.00
        else
          if not @job_seeker_privilege.nil?
            session[:discount_amount] =  @job_seeker_privilege.discount_value
            session[:credit_amount] =  @job_seeker_privilege.credit_value
          end
        end
      else
        @job_seeker_privilege = @job_seeker.job_seeker_activated_privilege
        session[:discount_amount] =  @job_seeker_privilege.discount_amount
        session[:credit_amount] =  @job_seeker_privilege.credit_amount
      end
    else
      if session[:job_seeker].ics_type_id == 3
          session[:discount_amount] =  19.99
          session[:credit_amount] =  0.00
      end
    end
    #To be Reviewed
    if not @job_seeker.payments[0].nil? and @job_seeker.payments[0].payment_purpose == $payment_purpose[:seeker_registration]
      @card_t = @job_seeker.payments[0].card_type
    end
    #To be Reviewed
    
    #session[:payment_type] = nil
    render :layout => 'registration'
  end
   
  def check_payment_options
    clear_payment_session
    amount_to_charge
    if !params[:coderequest][:promotional_code].blank?
      if @error_arr.length > 0
        session[:total_amount] = session[:paypal_amount] = session[:promotional_code_amount] = session[:promo_remaining_amt] = nil
        respond_to do |wants|
          wants.js {render 'check_payment_options_error_message_csv2', :format => [:js], :layout => false}
        end
      else
        respond_to do |wants|
          wants.js {render 'check_payment_options_show_confirmed_code_msg', :format => [:js], :layout => false}
        end
      end
      return
    end
  end
   
  def add_credit
    pc_obj = nil
    if not params[:coderequest].nil?
      if not params[:coderequest][:promotional_code].blank?
        pc_obj = PromotionalCode.valid_code_for_seeker(params[:coderequest][:promotional_code])
        if pc_obj.blank?
          @error_arr  << ["promotional_code","Invalid Promotional Code"]
        end
      else
        @error_arr  << ["promotional_code","Invalid Promotional Code"]
      end
    else
      @error_arr  << ["promotional_code","Invalid Promotional Code"]
    end

    if !params[:coderequest][:promotional_code].blank?
      if @error_arr.length > 0
        respond_to do |wants|
          wants.js {render 'add_credit_failure', :format => [:js], :layout => false}
        end
      else
        #Add to credit table
        updated_credit = session[:job_seeker].credit
        updated_credit.credit_value = updated_credit.credit_value + pc_obj.amount
        updated_credit.save
        reload_seeker_session
        
        #Consume Promocode
        PromotionalCode.consumed_save(pc_obj.id,pc_obj.amount,"job_seeker",session[:job_seeker].id)

        respond_to do |wants|
          wants.js {render 'add_credit_success', :format => [:js], :layout => false}
        end
      end
      return
    else
      respond_to do |wants|
        wants.js {render 'add_credit_failure', :format => [:js], :layout => false}
      end
    end
  end

  def make_payment
    #clear_payment_session()
    amount_to_charge
    #amount_to_charge_from_paypal()
    if params[:payment_type] == "promo"
      #amount_to_charge()
      #if !session[:promotional_remaining_amt].nil?
      #if session[:promotional_remaining_amt].to_i != 0
      pay_all_by_promo_code
      #end
    else
      if params[:payment_type] == "paypal_express"
        paypal_express_payment
      else
        paypal_pro_payment
      end
    end
    #render :text=>"Done"
    #      return
      
  end

  def credit_create_after_full_discount
    if not session[:job_seeker].ics_type_id == 3
      referral_fee_create
      credit_create
    end
    render :text => "Done"
  end
   
  def confirm_payment
    @express_error = false
    if params[:token].blank?
      redirect_to :action => 'index'
      return
    end
      
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    details_response = gateway.details_for(params[:token])
      
    if !details_response.success?
      @express_error = true
      @message = details_response.message
    else
      purchase = gateway.purchase(session[:paypal_amount].to_f * 100,  :ip=> get_remote_ip(), :payer_id => params[:PayerID],:token => params[:token])
      if !purchase.success?
        @express_error = true
        @message = purchase.message
      else
        if session[:promotional_code_amount] !=  0.00
          PromotionalCode.consumed_save(session[:promotional_code_id],session[:promotional_code_amount],"job_seeker",session[:job_seeker].id)
        end
        after_express_complete_payment(details_response.address,purchase)
        session[:paypal_success_msg] = 1
        session[:account_popup] = 1
        redirect_to :controller =>:payment,:action=>:index
        return
      end
    end
      
    if @express_error == true
      redirect_to :action => 'index'
      return
    end
  end
  
  def payment_complete
    @amount_value = session[:total_amount].to_f
    @paypal_amount = session[:paypal_amount].to_f
    @promotional_code_amount = session[:promotional_code_amount].to_f
    @promo_remaining_amt = session[:promo_remaining_amt].to_f
  end
       
  def after_express_complete_payment(address,purchase_obj)
    @job_seeker = JobSeeker.find(session[:job_seeker].id)
      
    @payment = Payment.new({:amount_charged => session[:total_amount],:paypal_amount=> session[:paypal_amount],
        :promotional_code_amount => session[:promotional_code_amount] ,:holder_name => address['name'],:card_type=> "NA",:card_num => "NA",:cvv => "NA",:expiry_date=>"NA",:billing_address_one=> address['company'].to_s + address['address1'].to_s,:billing_address_two=> address['address2'],:billing_city=> address['city'],:billing_state=>address['state'],:billing_zip=>address['zip'],:billing_country=> address['country'],
        :promotional_code_id=> session[:promotional_code_id]})
      
    @payment.payer_id= params[:PayerID]
    @payment.token_value = params[:token]
      
    @payment.id_of_transaction = purchase_obj.params["transaction_id"]
    @payment.paypal_status = purchase_obj.params["payment_status"]
    @payment.id_billing_agreement = purchase_obj.params["billing_agreement_id"]
            
    @payment.payment_purpose = $payment_purpose[:seeker_registration]
    @payment.payment_mode = return_payment_mode($payment_mode[:express])
    @payment.payment_success = true
    @payment.discount_amount = session[:discount_amount]
    @job_seeker.activated = true
    #@job_seeker.completed_registration_step = PAYMENT_STEP
    @job_seeker.payments << @payment
    @job_seeker.save(:validate => false)
    if not session[:discount_amount].nil?
      referral_fee_create
    end

    credit_create

    if not session[:discount_amount].nil? or not session[:credit_amount].nil?
      # Mail for Privileged Employer
    else
      # Mail for Normal Employer
    end
    session[:paypal_amount] = 0.00
    reload_seeker_session
    #PromotionalCode.consumed_save(session[:promotional_code_id],session[:total_amount],"job_seeker",session[:job_seeker].id)
    #self.paypal_status = paypal_verified_object.params['payment_status']
  end

  def set_completion_step
    js = JobSeeker.where("id=?", session[:job_seeker].id).first
    if js.activated == false
      js.activated = true
    end
    js.completed_registration_step = PAYMENT_STEP
    js.save(:validate => false)
    render :text => "job seeker updated"
  end
  
  private
  
  def validate_current_step
    if !(session[:job_seeker].completed_registration_step.to_i == PAIRING_BASICS_STEP)
      redirect_to(redirect_to_registration_step())
      return false
    end
  end
  
  def paypal_express_payment
    if !session[:paypal_amount].nil?
      paypal_chargeable_amount = session[:paypal_amount]
    else
      paypal_chargeable_amount = REGISTRATION_COST
    end
        
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    setup_response = gateway.setup_purchase(paypal_chargeable_amount.to_f * 100,
      :ip                => get_remote_ip(),
      :return_url        => url_for(:controller=>:payment,:action => 'confirm_payment', :only_path => false),
      :cancel_return_url => url_for(:controller=>:payment,:action => 'index', :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end
  
  def paypal_pro_payment
    @job_seeker = JobSeeker.where(:id => session[:job_seeker].id).first
    if !session[:paypal_amount].nil?
      paypal_chargeable_amount = session[:paypal_amount]
    else
      paypal_chargeable_amount = REGISTRATION_COST
    end
    holder_name = params[:fname] + " " + params[:lname]
    expiry_date = params[:month] + "/" + params[:year]
    billing_contact = params[:billing_area_code] + "-" + params[:billing_telephone_number]
    card_type = params[:card_type]
    @payment_pro =  Payment.new({:amount_charged => REGISTRATION_COST,
        :paypal_amount=> session[:paypal_amount],
        :promotional_code_amount => session[:promotional_code_amount] ,
        :holder_name => holder_name,
        :card_type=> card_type,
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
        :promotional_code_id=> session[:promotional_code_id],
        :discount_amount => session[:discount_amount]
      })
    if !@payment_pro.valid?
      @payment_pro.errors.each{|k,v|
        @error_arr  << [k,v]
      }
    end
        
    if @error_arr .length > 0
      @error_json = json_from_error_arr(@error_arr )
      render :action=>"index"
      return
    end
        
        
    payment_success,payment_error,paypal_verified_object = @payment_pro.make_payment(get_remote_ip())
    logger.info("**********payment_success #{payment_success} and payment_error #{payment_error} and paypal_verified_object #{paypal_verified_object.inspect}")
    if payment_success
      if session[:promotional_code_amount] !=  0.00
        PromotionalCode.consumed_save(session[:promotional_code_id],session[:promotional_code_amount],"job_seeker",session[:job_seeker].id)
      end
      @payment_pro.set_values_after_pro_payment_success(paypal_verified_object,$payment_purpose[:seeker_registration],return_payment_mode($payment_mode[:pro]))
      @job_seeker.activated = true
      #@job_seeker.completed_registration_step = PAYMENT_STEP
      @job_seeker.payments << @payment_pro
      @job_seeker.save(:validate => false)
      JobSeekerFollowCompany.create({:company_id => params[:company_id],:job_seeker_id => session[:job_seeker].id})
      if not session[:discount_amount].nil?
        referral_fee_create
      end

      credit_create
      
      reload_seeker_session

      #PromotionalCode.consumed_save(session[:promotional_code_id],session[:total_amount],"job_seeker",session[:job_seeker].id)
      session[:paypal_amount] = 0.00
      @payment_pro.save(:validate => false)
      #redirect_to :controller=>:payment,:action=>:index
      session[:cc_success_msg] = 1
      session[:account_popup] = 1
      reload_seeker_session
      respond_to do |wants|
        wants.js {render 'check_payment_options_payment_success_message', :format => [:js], :layout=>false }
      end
      #render :update do |page|
      #page.call "check_payment_options.submit_payment_form"
      #page.call "finish_payment.show_finish_popup", card_type
      #page.call "check_payment_options.payment_success_message"
      #page.call "hideBlockShadow"
      #end
      return
      #return
    else
      @error_json = "[{'key' : 'payment', 'msg' : '" + payment_error + "'}]"
      #render :action=>"index"
      respond_to do |wants|
        wants.js {render 'check_payment_options_show_error_message', :format => [:js], :layout=>false }
      end
      #render :update do |page|
      #page.replace_html 'popup-heading', 'UNABLE TO VERIFY'
      #page.call "check_payment_options.show_error_message"
      #page.call "hideBlockShadow"
      #end
      return
    end
  end
  
  def amount_to_charge
    if session[:total_amount].nil?
      if session[:discount_amount].nil?
        session[:total_amount] = REGISTRATION_COST
      else
        session[:total_amount] = ((REGISTRATION_COST - session[:discount_amount])*100).round.to_f / 100
      end
    end
    if session[:paypal_amount].nil?
      if session[:discount_amount].nil?
        session[:paypal_amount] = REGISTRATION_COST
      else
        session[:paypal_amount] = ((REGISTRATION_COST - session[:discount_amount])*100).round.to_f / 100
      end
    end
    if session[:promotional_code_amount].nil?
      session[:promotional_code_amount] =  0.00
    end
    logger.info("************params[:coderequest] #{params[:coderequest].inspect}")
    if not params[:coderequest].nil?
      if not params[:coderequest][:promotional_code].blank?
        pc_obj = PromotionalCode.valid_code_for_seeker(params[:coderequest][:promotional_code])
        if pc_obj.blank?
          @error_arr  << ["promotional_code","Invalid Promotional Code"]
        else
          session[:promotional_code_id] = pc_obj.id
          session[:total_amount], session[:paypal_amount], session[:promotional_code_amount], session[:promo_remaining_amt] = pc_obj.amount_after_deduction(session[:total_amount])
          logger.info("************session[:total_amount] #{session[:total_amount]} and session[:paypal_amount] #{session[:paypal_amount]} and session[:promotional_code_amount] #{session[:promotional_code_amount]} and session[:promo_remaining_amt] #{session[:promo_remaining_amt]}")
        end
      end
    end
  end
    
  def amount_to_charge_from_paypal
    session[:total_amount] = REGISTRATION_COST
    session[:paypal_amount] =  REGISTRATION_COST
    session[:promotional_code_amount] =  0.00
  end
  
  def pay_all_by_promo_code
    @job_seeker = JobSeeker.where("id=?", session[:job_seeker].id).first
    @payment = return_payment_obj_for_promo_code(REGISTRATION_COST,session[:promotional_code_id], session[:promotional_code_amount], $payment_purpose[:seeker_registration])
    @payment.discount_amount = session[:discount_amount]
    @payment.payment_success = true
    @job_seeker.activated = true
    @job_seeker.save(:validate => false)

    if not session[:discount_amount].nil? or not session[:credit_amount].nil?
      referral_fee_create
    end

    credit_create
    #@job_seeker.completed_registration_step = PAYMENT_STEP
    session[:account_popup] = 1
    @job_seeker.payments << @payment
    @job_seeker.save(:validate => false)
    reload_seeker_session

    if session[:paypal_amount].to_i != 0
      PromotionalCode.consumed_save(session[:promotional_code_id],session[:promotional_code_amount],"job_seeker",session[:job_seeker].id)
    else
      PromotionalCode.consumed_save(session[:promotional_code_id],session[:total_amount],"job_seeker",session[:job_seeker].id)
    end
    
    if not session[:discount_amount].nil? or not session[:credit_amount].nil?
      # Mail for Privileged Employer
    else
      # Mail for Normal Employer
    end
    render :text=>"Done"
    return
    #redirect_to :controller=>:payment,:action=>:index
      
  end

  def referral_fee_create
    if !session[:job_seeker].track_shared_job_id.nil?
      job = Job.find_by_id(session[:job_seeker].track_shared_job_id)
      ReferralFee.create({:job_seeker_id => session[:job_seeker].id, :company_id => job.company_id, :job_id => session[:job_seeker].track_shared_job_id, :share_platform_id => session[:job_seeker].track_platform_id, :discount_amount => session[:discount_amount], :credit_amount => session[:credit_amount]})
    end
    ReferralFee.create({:job_seeker_id => session[:job_seeker].id, :company_id => session[:job_seeker].track_shared_company_id, :share_platform_id => session[:job_seeker].track_platform_id, :discount_amount => session[:discount_amount], :credit_amount => session[:credit_amount]}) if !session[:job_seeker].track_shared_company_id.nil?
  end

  def credit_create
    credit_amount = 5.00
    if not session[:credit_amount].nil?
      credit_amount = credit_amount + session[:credit_amount]
    end
    PromotionalCode.create_random_code_site_activation(credit_amount, $promo_code_origination[:site_activation_credit], session[:job_seeker].id)
    Credit.create({:job_seeker_id => session[:job_seeker].id, :credit_value => session[:credit_total]})
    if not session[:promo_remaining_amt].nil?
      PromotionalCode.consumed_save(session[:promotional_code_id], session[:promo_remaining_amt], "job_seeker", session[:job_seeker].id)
    end
  end
    
end
