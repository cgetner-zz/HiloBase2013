# coding: UTF-8

class PurchaseProfilePaymentController < ApplicationController
  
  layout false
      
  before_filter :employer_with_complete_registration
  before_filter :check_for_deleted_users
  before_filter :check_for_suspended_users
  before_filter :check_job_seeker_deleted_viewed_profile, :only => [:authenticate_one_click, :credit_card_payment, :exclude_payment]
      
  def index
    # @job_seeker = JobSeeker.find(params[:seeker_id])
    session[:seeker_id_one_click] = params[:seeker_id]
    session[:job_id_one_click] = params[:job_id]
    @payment = Payment.new
    if session[:employer].is_root?
      @old_payment_obj, @promo_code_obj = Payment.employer_old_payment_obj(session[:employer].id,false)
    else
      @old_payment_obj, @promo_code_obj = Payment.employer_old_payment_obj(session[:employer].root_id,false)
    end
    render 'seeker_view', :formats=>[:js], :layout=>false
#    if @old_payment_obj.nil?
#      render :update do |page|
#        page.replace_html "cc_billing_popup", :partial => "/purchase_profile_payment/credit_card_popup"
#        page.call "employer_click_payment.credit_card_payment_emp"
#      end
#    else
#      render :update do |page|
#        page.call "employer_click_payment.one_click_popup",@old_payment_obj.card_type
#      end
#    end
    return
  end

  def exclude_payment
    @seeker_id = params[:seeker_id]
    @job_id = params[:job_id]
    payment = Payment.new()
    payment.job_seeker_id = params[:seeker_id]
    payment.job_id = params[:job_id]
    payment.payment_purpose = "purchase_profile_excluded"
    payment.save(:validate => false)

    PurchasedProfile.new({:company_id=>session[:employer].company_id, :employer_id => session[:employer].id, :job_seeker_id => params[:seeker_id], :payment_id=>payment.id, :job_id => params[:job_id]}).save(:validate => false)
    notification = JobSeekerNotification.new
    notification.job_seeker_id = params[:seeker_id]
    notification.job_id = params[:job_id]
    notification.company_id = session[:employer].company_id
    notification.notification_type_id = 3
    notification.notification_message_id = 5
    notification.visibility = true
    notification.save
    #job seeker feed
    js_ids = Array.new
    js_ids<<params[:seeker_id].to_i
    job = Job.find_by_id(params[:job_id].to_i)
    if job.active
      if job.internal
        job.company.path_ids.each do |c|
          BroadcastController.new.delay(:priority => 6).opportunities_internal(c, js_ids)
        end
      else
        job.company.path_ids.each do |c|
          BroadcastController.new.delay(:priority => 6).opportunities_internal(c, js_ids)
        end
        BroadcastController.new.delay(:priority => 6).opportunities_normal(js_ids)
      end
    end
    
    #employer feed
#    job.employer.ancestor_ids.each do |id|
#      BroadcastController.new.delay(:priority => 6).employer_dashboard(id, session[:employer].id)
#    end
#    BroadcastController.new.delay(:priority => 6).employer_dashboard(job.employer.id, session[:employer].id)
#    BroadcastController.new.delay(:priority => 6).purchased_position(job.company_id, session[:employer].id)
    #


    #changes (checked)
    BroadcastController.new.employer_update(session[:employer].company_id, "dashboard", [@job_id.to_i], [@seeker_id.to_i])
    BroadcastController.new.employer_update(session[:employer].company_id, "candidate_pool", [@job_id.to_i])

    job_seeker = JobSeeker.where(:id => params[:seeker_id]).first
    if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
      Notifier.email_job_seeker_notifications(job_seeker, notification).deliver
      job_seeker.notification_email_time = DateTime.now
      job_seeker.save(:validate => false)
    end
  end
      
  def payment_details
    @resp_case = ""
    if params[:promotional_code].blank? and params[:transaction_type].blank?
      @resp_case = "no_option"
      return
    end
            
    init_purchase_profile_pay()
            
    ##################################################
           
                    
    if params[:transaction_type].blank?
      @resp_case = "message"
      @message = "Select one of the transaction options previous transaction details or make new payment"
      return
    end
           
    if  params[:transaction_type] =="old" and !params[:past_promo_code].blank?
      params[:promotional_code] = params[:past_promo_code]
    end
               
    purchase_profile_charge_amount()

    if params[:transaction_type] == "old"
      if !params[:past_promo_code].blank? and (session[:profile_pay][:total_amount] != session[:profile_pay][:promotional_code_amount])
        @resp_case = "message"
        @message = "You have only $#{sprintf('%.2f', session[:profile_pay][:promotional_code_amount])} in your promotional code.<br/>Make new payment to pay $#{sprintf('%.2f', session[:profile_pay][:total_amount])}."
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
      if session[:profile_pay][:total_amount] == session[:profile_pay][:promotional_code_amount]
        @resp_case = "submit_form"
        return
      else
        @resp_case = "message"
        @message = "Select one of the payment options Credit Card or Paypal Express Checkout"
        return
      end
    end
            

    if !params[:payment_type].blank?
              
      if session[:profile_pay][:total_amount] == session[:profile_pay][:promotional_code_amount]
        @resp_case = "confirm"
        @message = "You have sufficient balance in your promotional code.<br/>$#{sprintf('%.2f', session[:profile_pay][:promotional_code_amount])} will be deducted from your promotional code.<br/>No paypal transaction will be made.<br/>Please click ok to confirm."
        return
      else
        if session[:profile_pay][:promotional_code_amount].to_f == 0.0
          @resp_case = "submit_form"
          return
        else
          @resp_case = "confirm"
          @message = "You will be charged $#{sprintf('%.2f', session[:profile_pay][:promotional_code_amount])} from your promotional code and $#{sprintf('%.2f', session[:profile_pay][:paypal_amount])} from paypal.<br/>Please click ok to confirm."
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
    @express_error = false
    if params[:token].blank?
      redirect_to :controller => 'employer_account'
      return
    end
            
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    details_response = gateway.details_for(params[:token])
            
    if !details_response.success?
      @express_error = true
      @message = details_response.message
    else
      purchase = gateway.purchase(PURCHASE_PROFILE_COST.to_f * 100,  :ip=> get_remote_ip(), :payer_id => params[:PayerID],:token => params[:token])
      if !purchase.success?
        @express_error = true
        @message = purchase.message
      else
        @notification = JobSeekerNotification.new
        @notification.job_seeker_id = session[:seeker_id_one_click]
        @notification.job_id = session[:job_id_one_click]
        @notification.company_id = session[:employer].company_id
        @notification.notification_type_id = 3
        @notification.notification_message_id = 5
        @notification.visibility = true
        @notification.save

        job_seeker = JobSeeker.where(:id => session[:seeker_id_one_click]).first
        if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
          Notifier.email_job_seeker_notifications(job_seeker, @notification).deliver
          job_seeker.notification_email_time = DateTime.now
          job_seeker.save(:validate => false)
        end
                        
        after_express_complete_payment(details_response.address,purchase)
        session[:one_click_card] = nil
        session[:express_payment_complete] = 1
        #session[:payment_complete] = true
        #session[:job_pay_job_id] = session[:profile_pay][:job_id]
        #redirect_to :controller =>:employer_account,:action=>:index
        redirect_to CGI::unescape(params[:url])
        return
      end
    end
            
    if @express_error == true
      #session[:payment_complete] = false
      redirect_to :controller =>:employer_account,:action=>:index
      return
    end
  end

  def authenticate_one_click
    @employer_authenticate = Employer.authenticate_employer(params[:pay_name],params[:pay_pass])
    if @employer_authenticate.blank? or params[:pay_name] != session[:employer].email

      render 'authenticate_error', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "employer_click_payment.authenticate_error"
      #      end
      return
    else
      @flag = make_payment_with_old_transaction
      if @flag == true
        if session[:one_click_card].nil?
          session[:one_click_card] = {:time => Time.now()}
        end
        @notification = JobSeekerNotification.new
        @notification.job_seeker_id = session[:seeker_id_one_click]
        @notification.job_id = session[:job_id_one_click]
        @notification.company_id = session[:employer].company_id
        @notification.notification_type_id = 3
        @notification.notification_message_id = 5
        @notification.visibility = true
        @notification.save

        job_seeker = JobSeeker.where(:id => session[:seeker_id_one_click]).first
        if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
          Notifier.email_job_seeker_notifications(job_seeker, @notification).deliver
          job_seeker.notification_email_time = DateTime.now
          job_seeker.save(:validate => false)
        end
      end
      render 'employer_click_payment_one_click_payment_success', :formats=>[:js], :layout=>false
    end
  end

  def authenticate_one_click_session_exist
    flag = make_payment_with_old_transaction
      if flag == true
        @notification = JobSeekerNotification.new
        @notification.job_seeker_id = session[:seeker_id_one_click]
        @notification.job_id = session[:job_id_one_click]
        @notification.company_id = session[:employer].company_id
        @notification.notification_type_id = 3
        @notification.notification_message_id = 5
        @notification.visibility = true
        @notification.save

        job_seeker = JobSeeker.where(:id => session[:seeker_id_one_click]).first
        if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
          Notifier.email_job_seeker_notifications(job_seeker, @notification).deliver
          job_seeker.notification_email_time = DateTime.now
          job_seeker.save(:validate => false)
        end
      end
    return flag
  end

  def show_credit_card
    render 'show_credit_card', :formats=>[:js], :layout=>false
#    render :update do |page|
#      page.replace_html "cc_billing_popup", :partial => "/purchase_profile_payment/credit_card_popup"
#      page.call "employer_click_payment.credit_card_payment"
#    end
    return
  end

  def credit_card_payment
    @flag = paypal_pro_payment
    if @flag == false
      render 'credit_card_payment_failure', :formats=>[:js], :layout=>false
#      render :update do |page|
#        page.call "check_payment_options.show_error_message"
#      end
      return
    elsif @flag == true
      @notification = JobSeekerNotification.new
      @notification.job_seeker_id = session[:seeker_id_one_click]
      @notification.job_id = session[:job_id_one_click]
      @notification.company_id = session[:employer].company_id
      @notification.notification_type_id = 3
      @notification.notification_message_id = 5
      @notification.visibility = true
      @notification.save

      job_seeker = JobSeeker.where(:id => session[:seeker_id_one_click]).first
      if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
        Notifier.email_job_seeker_notifications(job_seeker, @notification).deliver
        job_seeker.notification_email_time = DateTime.now
        job_seeker.save(:validate => false)
      end
      session[:one_click_card] = nil
      render 'employer_click_payment_one_click_payment_success', :formats=>[:js], :layout=>false
#      render :update do |page|
#        page.call "employer_click_payment.one_click_payment_success", session[:seeker_id_one_click], session[:job_id_one_click], session[:employer].id
#      end
      return
    end
  end

  def paypal_payment
    url = params[:url]
    paypal_express_payment(url)
  end
      
  private
         
  def make_transaction
    if session[:profile_pay][:total_amount] == session[:profile_pay][:promotional_code_amount]
      pay_all_by_promo_code
    else
      if !params[:transaction_type].blank? and params[:transaction_type][0] == "new"
        if params[:payment_type] == "paypal_express"
          paypal_express_payment
        else
          paypal_pro_payment
        end
      else
        if make_payment_with_old_transaction(session[:profile_pay][:paypal_amount])
          @resp_case = "payment_success"
        else
          @error_json = json_from_error_arr([["payment_fail","Failed to make transaction"]])
          @resp_case = "error"
        end
      end
    end
  end
    
  def pay_all_by_promo_code
    @employer = Employer.find(session[:employer].id)
    @payment = return_payment_obj_for_promo_code(session[:profile_pay][:total_amount],session[:profile_pay][:promotional_code_id],get_payment_purpose())
    @payment.payment_success = true
    @payment.profile_id = session[:profile_pay][:profile_id]
    @payment.employer_id = session[:employer].id
    @payment.save(:validate => false)
    save_purchased_profile(@payment)
    consumed_promotional_code()
          
    @resp_case = "payment_success"
  end
      
  def paypal_express_payment(url)
    paypal_chargeable_amount = PURCHASE_PROFILE_COST
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    #request.env["HTTP_REFERER"]
    #if controller.controller_name == "employer_account"
    setup_response = gateway.setup_purchase(paypal_chargeable_amount.to_f * 100,
      :ip                => get_remote_ip(),
      :return_url        => url_for(:controller=>:purchase_profile_payment,:action => 'confirm_payment', :url => url, :only_path => false),
      :cancel_return_url => url_for(:controller=>:employer_account,:action => :index, :only_path => false)
    )

    #:return_url        => "/purchase_profile_payment/confirm_payment?url=XXXX", #:only_path => true,
    #:return_url       => CGI::unescape(url),

    redirect_to gateway.redirect_url_for(setup_response.token)
  end
      
      
  def after_express_complete_payment(address,purchase_obj)
    @employer = Employer.find(session[:employer].id)
            
    @payment = Payment.new({:amount_charged => PURCHASE_PROFILE_COST,:paypal_amount=> PURCHASE_PROFILE_COST,
        :promotional_code_amount => "NA" ,:holder_name => address['name'],:card_type=> "NA",:card_num => "NA",:cvv => "NA",:expiry_date=>"NA",:billing_address_one=> address['company'].to_s + address['address1'].to_s,:billing_address_two=> address['address2'],:billing_city=> address['city'],:billing_state=>address['state'],:billing_zip=>address['zip'],:billing_country=> address['country'],
        :promotional_code_id=> "NA"})
            
    @payment.payer_id= params[:PayerID]
    @payment.token_value = params[:token]
            
    @payment.employer_id = session[:employer].id
    @payment.id_of_transaction = purchase_obj.params["transaction_id"]
    @payment.paypal_status = purchase_obj.params["payment_status"]
    @payment.id_billing_agreement = purchase_obj.params["billing_agreement_id"]
                  
    @payment.payment_purpose = $payment_purpose[:purchase_profile]
    @payment.payment_mode = $payment_mode[:express]
    @payment.payment_success = true
    @payment.profile_id = session[:seeker_id_one_click]
            
    @payment.save(:validate => false)
    save_purchased_profile(@payment)
            
  end
      
      
      
      
  def paypal_pro_payment
    holder_name = params[:fname] + " " + params[:lname]
    expiry_date = params[:month] + "/" + params[:year]
    billing_contact = params[:billing_area_code] + "-" + params[:billing_telephone_number]
    @payment =  Payment.new({:amount_charged => PURCHASE_PROFILE_COST,
        :paypal_amount =>  PURCHASE_PROFILE_COST,
        :holder_name => holder_name,
        :card_type=> params[:card_type],
        :card_num => params[:card_num],
        :cvv => params[:cvv],
        :expiry_date=> expiry_date,
        :billing_address_one=> params[:billing_address_one],
        :billing_address_two=> params[:billing_address_two],
        :billing_city=> params[:billing_city],
        :billing_state=>params[:billing_state],
        :billing_zip=>params[:billing_zip],
        :billing_country=>'US',
        :billing_contact=> billing_contact,
      })
            
    if !@payment.valid?
      @payment.errors.each{|k,v|
        @error_arr  << [k,v]
      }
    end
            
    if @error_arr .length > 0
                 
      return false
    end
            
    payment_success,payment_error,paypal_verified_object = @payment.make_payment(get_remote_ip())
    if payment_success
      @payment.set_values_after_pro_payment_success(paypal_verified_object,$payment_purpose[:purchase_profile],$payment_mode[:pro])
      @payment.employer_id = session[:employer].id
      @payment.profile_id = session[:seeker_id_one_click]
      @payment.save(:validate => false)
      save_purchased_profile(@payment)
      return true
    else
      @resp_case  = "error"
      @error_json = "[{'key' : 'payment', 'msg' : '" + payment_error + "'}]"
      return false
    end
  end
      
      
  def make_payment_with_old_transaction
    reload_employer_session
    if session[:employer].is_root?
      response,payment_obj,promo_obj = Payment.payment_with_old_transaction(session[:employer].id,"employer",get_remote_ip(),PURCHASE_PROFILE_COST,false)
    else
      if session[:employer].spending_flag
        emp_spend = SpendingLimit.where(:employer_id => session[:employer].id).last
        if emp_spend.available_balance - PURCHASE_PROFILE_COST >= 0
          response,payment_obj,promo_obj = Payment.payment_with_old_transaction(session[:employer].root_id,"employer",get_remote_ip(),PURCHASE_PROFILE_COST,false)
        else
          return "spend_crossed"
        end
      else
        response,payment_obj,promo_obj = Payment.payment_with_old_transaction(session[:employer].root_id,"employer",get_remote_ip(),PURCHASE_PROFILE_COST,false)
      end
    end
    if response == false
      return false
    else
      if response.success?
        new_payment_obj =  save_direct_payment_details(response,payment_obj)
        save_purchased_profile(new_payment_obj)
        if session[:employer].spending_flag
          SpendingLimit.consumed_save(session[:employer].id)
        end
        return true
      else
        return false
      end
    end      
  end
      
  def save_payment_details_with_promocode(payment_obj,promo_obj)
    hash_obj = {     :amount_charged => session[:profile_pay][:total_amount],
      :payment_success=>true,
      :billing_address_one=>"NA",
      :billing_address_two=>"NA",
      :billing_city=>"NA",
      :billing_state=>"NA",
      :billing_zip=>"NA",
      :billing_country=>"NA",
      :payment_purpose=>get_payment_purpose(),
      :payment_mode=>$payment_mode[:promo_code],
      :promotional_code_amount => session[:profile_pay][:total_amount],
      :employer_id => session[:employer].id,
      :profile_id => session[:profile_pay][:profile_id],
      :promotional_code_id => session[:profile_pay][:promotional_code_id]
    }
    _payment = Payment.new(hash_obj)
    _payment.save(:validate => false)
    return _payment
  end
      
  def save_direct_payment_details(response,payment_obj)
    if response.params["transaction_type"] == "mercht-pmt"
                   
      hash_obj = {:amount_charged => PURCHASE_PROFILE_COST,
        :id_of_transaction => response.params["transaction_id"],
        :paypal_status => response.params["payment_status"],
        :payment_success=>true,
        :billing_address_one=>payment_obj.billing_address_one,
        :billing_address_two=>payment_obj.billing_address_two,
        :billing_city=>payment_obj.billing_city,
        :billing_state=>payment_obj.billing_state,
        :billing_zip=>payment_obj.billing_zip,
        :billing_country=>payment_obj.	billing_country,
        :payment_purpose=>$payment_purpose[:purchase_profile],
        :payment_mode=>$payment_mode[:ref_transaction],
        :paypal_amount => response.params["gross_amount"],
        :id_billing_agreement => response.params["billing_agreement_id"]
      }
                   
    else
      hash_obj = {:amount_charged => PURCHASE_PROFILE_COST,:paypal_amount => response.params["amount"],:paypal_status => response.params["ack"],:id_of_transaction => response.params["transaction_id"],:payment_success=>true,:billing_address_one=>payment_obj.billing_address_one,:billing_address_two=>payment_obj.billing_address_two,:billing_city=>payment_obj.billing_city,:billing_state=>payment_obj.billing_state,:billing_zip=>payment_obj.billing_zip,:billing_country=>payment_obj.	billing_country,:payment_purpose=>$payment_purpose[:purchase_profile],:payment_mode=>$payment_mode[:ref_transaction]}
    end
               
    hash_obj.update({:profile_id => session[:seeker_id_one_click],:promotional_code_id => "NA",:employer_id => session[:employer].id})
    _payment = Payment.new(hash_obj)
    _payment.save(:validate => false)
    return _payment
  end
    
  def save_purchased_profile(payment)
    PurchasedProfile.new({:company_id=>session[:employer].company_id, :employer_id => session[:employer].id, :job_seeker_id => payment.profile_id, :payment_id=>payment.id, :job_id => session[:job_id_one_click]}).save(:validate => false)
  end
      
  def consumed_promotional_code
    PromotionalCode.consumed_save(session[:profile_pay][:promotional_code_id],session[:profile_pay][:promotional_code_amount],"employer",session[:employer].id)
  end
      
  def get_payment_purpose
    case session[:profile_pay][:pay_for]
    when "purchase_profile"
      return $payment_purpose[:purchase_profile]
    end
  end
      
  def purchase_profile_charge_amount()
    session[:profile_pay][:paypal_amount] = session[:profile_pay][:total_amount] = PURCHASE_PROFILE_COST
    session[:profile_pay][:promotional_code_amount] =  0.0
            
    if not params[:promotional_code].blank?
      pc_obj = PromotionalCode.valid_code_for_employer(params[:promotional_code],session[:employer].id)
      if pc_obj.blank?
        @error_arr  << ["promotional_code","Invalid Promotional Code"]
      else
        session[:profile_pay][:promotional_code_id] = pc_obj.id
        session[:profile_pay][:total_amount], session[:profile_pay][:paypal_amount], session[:profile_pay][:promotional_code_amount], session[:profile_pay][:promo_remaining_amt] = pc_obj.amount_after_deduction(session[:profile_pay][:total_amount])
      end
    end
  end
      
  def init_purchase_profile_pay
    session[:profile_pay] = {:total_amount=>0.0,:paypal_amount=>0.0,:promotional_code_amount=>0.0,:promo_remaining_amt=>0.0,:pay_for => params[:pay_for],:profile_id => params[:seeker_id]}
  end
end