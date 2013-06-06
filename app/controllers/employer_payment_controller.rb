# coding: UTF-8

class EmployerPaymentController < ApplicationController
  layout "employer_v2"
  before_filter :required_loggedin_employer
  before_filter :validate_current_step,:except=>[:payment_complete, :company_info]

  def index
     
    @payment = Payment.new
    check_payment = Payment.where("employer_id = ? ", session[:employer].id).last
    @company_info = Company.select("companies.*, e.completed_registration_step").joins("INNER JOIN employers e ON companies.id = e.company_id").where("e.id = #{session[:employer].id}").first
    @reset = true if !@company_info.nil?
    @payment_done = (check_payment.nil? || check_payment.paypal_status != "Completed") ? false : true
    @states = State.all
  end

  def load_payment_form
    render :partial => "payment_form"
  end

  def company_info
    # Commented as payment not required
    #if(params[:submit_type] != "1")#forget about company informations if submit_type = 1 (save & return)
    #  check_payment = Payment.find(:last, :conditions => "employer_id = #{session[:employer].id}")  #check for the last payment
    #  @payment_done = (check_payment.nil? || check_payment.paypal_status != "Completed") ? false : true
    #  if(check_payment.nil? || check_payment.paypal_status != "Completed")
    #      @error_arr = "Payement informations are missing"
    #      render :action => :index, :layout => true
    #      return
    #  end
    #end
    # /Commented as payment not required
       
    id = params[:id]
    @employer = Employer.where("id = ?", session[:employer].id).first
       
       
    # Commented as payment not required
    #if(params[:new_record] == "0") #select company from auto fill
    #     @company = Company.find(id);
    #     @employer.update_attributes(:company_id => params[:id].to_i)
    #     @employer.update_attributes(:completed_registration_step => EMPLOYER_PAYMENT_STEP) if(params[:submit_type] == "0") #if submit the form
    #     reload_employer_session(@employer)
    #else
    #     if(id != 0)
    #         @company = Company.find(id);
    #     else
    #
    #     end
    #end
    # /Commented as payment not required
    if(id=="")
      @company = Company.new()
    else
      @company = Company.where("id = ?", id.to_i).first
    end
       
       
    @company_info = @company
    @company.name = params[:name]
    @company.street_one = params[:address_two]
    @company.city = params[:city]
    @company.country = params[:country]
    @company.zip = params[:zip_code]
    @company.state = params[:state]
    @company.phone = params[:area_code].empty? ? "#{params[:telephone]}" : "#{params[:area_code]}-#{params[:telephone]}"
    @company.website = params[:website]

    total_field = params[:name] + params[:address_two] + params[:city] + params[:zip_code] + params[:telephone] + params[:website]
       
    if(params[:submit_type] == "1") #save and return
      @employer.update_attributes(:company_id => nil) #reset company id for new entry
      @employer.update_attributes(:completed_registration_step => EMPLOYER_ACCOUNT_SETUP_STEP)
      @company.save(:validate=>false) if(!total_field.empty?)
      @employer.update_attributes(:company_id => @company.id) #save without validation and return
      redirect_to :controller => "login", :action => "logout"
      return
    end
       
    if @company.save(:validate => false)
      @employer.update_attributes(:company_id => @company.id)
      @employer.update_attributes(:completed_registration_step => EMPLOYER_PAYMENT_STEP) if (!@employer.company_id.nil?)
      @employer.update_attributes(:activated => 1)
      reload_employer_session(@employer)
      session[:account_popup] = true
      redirect_to :controller => "employer_account", :action => "index"
      return
    else
      @company.errors.each{|k,v|
        @error_arr  << [k,v]
      }
      @reset = true
      @error_json = json_from_error_arr(@error_arr)
      render :action => :index, :layout => true
      return
    end
  end
  #to search the presence of a company
  def search_company
    @company = Company.where("name = ?", params[:name]).first
    emp = ""
    if(!@company.nil?)
      emp = Employer.where("id = #{session[:employer].id}").first
    end
    if !@company.nil?
      if @company.id.to_i != emp.company_id.to_i
        render :text => "Company exists"
      else
        render :text => "Company doesn't exist"
      end
    else
      render :text => "Company doesn't exist"
    end
  end

  def set_company
    id = params[:id]
    return if (id.nil?)
    @company_info = Company.where("id = ?", id).first
    if !@company_info.nil?
      #@employer = Employer.where("id = ?",session[:employer].id)
      #@employer.update_attributes(:company_id => @company_info.id)
      @check_payment = Payment.where("employer_id = ?",session[:employer].id).last
      @payment_done = (!@check_payment.nil? && @check_payment.paypal_status == "Completed") ? true : false
      reload_employer_session(@employer)
    end
    @reset = true
    render :partial => "company_form"
  end

  def make_payment
    clear_payment_session()
    resp = ""
    if params[:payment_type] == "paypal_express"
      resp = paypal_express_payment()
    else
      resp = paypal_pro_payment()
      render :text => resp
      return
    end
  end

  def verify_payment()
    render :text => true
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
      purchase = gateway.purchase(session[:order_total].to_f * 100,  :ip=> get_remote_ip(), :payer_id => params[:PayerID],:token => params[:token])
      if !purchase.success?
        @express_error = true
        @message = purchase.message
      else
        after_express_complete_payment(details_response.address,purchase)
        redirect_to :controller =>:employer_payment,:action=>:index
        return
      end
    end

    if @express_error == true
      redirect_to :action => 'index'
      return
    end
  end

  def payment_complete
    @amount_value = session[:order_total]
  end

  def after_express_complete_payment(address,purchase_obj)
    @employer = Employer.find(session[:employer].id)

    @payment = Payment.new({:amount_charged => session[:order_total],
        :paypal_amount =>  session[:order_total],
        :holder_name => address['name'],:card_type=> "NA",:card_num => "NA",:cvv => "NA",:expiry_date=>"NA",:billing_address_one=> address['company'].to_s + address['address1'].to_s,:billing_address_two=> address['address2'],:billing_city=> address['city'],:billing_state=>address['state'],:billing_zip=>address['zip'],:billing_country=> address['country']})

    @payment.payer_id= params[:PayerID]
    @payment.token_value = params[:token]

    @payment.id_of_transaction = purchase_obj.params["transaction_id"]
    @payment.paypal_status = purchase_obj.params["payment_status"]
    @payment.id_billing_agreement = purchase_obj.params["billing_agreement_id"]

    @payment.payment_purpose = $payment_purpose[:employer_registration]
    @payment.payment_mode = return_payment_mode($payment_mode[:express])
    @payment.payment_success = true
    @employer.activated = true
    #@employer.completed_registration_step = EMPLOYER_PAYMENT_STEP if (!@employer.company_id.nil?)
    @employer.payments << @payment
    @employer.save(:validate => false)
    reload_employer_session()
  end

  private

  def validate_current_step
    if !request.xhr?
      redirect_to(redirect_to_employer_registration_step()) if session[:employer].completed_registration_step.to_i != EMPLOYER_ACCOUNT_SETUP_STEP
      return
    end
  end

  def paypal_express_payment
    amount_to_charge = amount_after_discount()
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    setup_response = gateway.setup_purchase(amount_to_charge.to_f * 100,
      :ip                => get_remote_ip(),
      :return_url        => url_for(:controller=>:employer_payment,:action => 'confirm_payment', :only_path => false),
      :cancel_return_url => url_for(:controller=>:employer_payment,:action => 'index', :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def paypal_pro_payment
    @employer = Employer.find(session[:employer].id)
    amount_to_charge = amount_after_discount()

    holder_name = "#{params[:holder_first_name]} #{params[:holder_last_name]}"
    expiry_date = "#{params[:month].to_s}" + "/" + "#{params[:year].to_s}"
    #Billing country hardcoded to US
    @payment =  Payment.new({:amount_charged => amount_to_charge ,:paypal_amount =>  session[:order_total],:holder_name => holder_name,:card_type=> params[:card_type],:card_num => params[:card_num],:cvv => params[:cvv],:expiry_date=>expiry_date, :company_name=>params[:payment_company_name], :billing_address_one=> params[:billing_address_one],:billing_address_two=> params[:billing_address_two],:billing_city=> params[:billing_city],:billing_state=>params[:billing_state],:billing_zip=>params[:billing_zip],:billing_country=>"US"})

    if !@payment.valid?
      @payment.errors.each{|k,v|
        @error_arr  << [k,v]
      }
    end

    if @error_arr .length > 0
      @error_json = json_from_error_arr(@error_arr )
      #render :action=>"index"
      return "#{@error_json}"
    end
    payment_success,payment_error,paypal_verified_object = @payment.make_payment(get_remote_ip())
    if payment_success
      @payment.set_values_after_pro_payment_success(paypal_verified_object,$payment_purpose[:employer_registration],return_payment_mode($payment_mode[:pro]))
      @employer.activated = true
      #@employer.completed_registration_step = EMPLOYER_PAYMENT_STEP
      @employer.payments << @payment
      @employer.save(:validate => false)
      reload_employer_session()
      #redirect_to :controller=>:employer_payment,:action=>:index
      return "done"
    else
      @error_json = "[{'key' : 'payment', 'msg' : '" + payment_error + "'}]"
      #render :action=>"index"
      return "#{@error_json}"
    end
    return "done"
  end

  def amount_after_discount
    dollar_value = EMPLOYER_REGISTRATION_COST
    session[:order_total] =   dollar_value
    return dollar_value
  end

end