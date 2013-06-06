# coding: UTF-8

class Payment < ActiveRecord::Base
  ##RSPEC: Can't be tested
  attr_accessible :amount_charged, :paypal_amount, :payment_success, :payment_purpose, :promotional_code_amount, :holder_name, :card_type, :card_num, :cvv, :expiry_date, :billing_address_one, :billing_address_two, :billing_city, :billing_state, :billing_zip, :billing_country, :promotional_code_id, :payment_mode, :billing_contact, :paypal_status, :id_of_transaction, :job_id, :job_seeker_id, :profile_id, :employer_id, :discount_amount, :credit_amount, :id_billing_agreement

  belongs_to :job_seeker
  belongs_to :employer

  has_one :purchased_profile

  attr_accessor :card_num,:cvv,:holder_name,:expiry_date

  validates :amount_charged, :presence => true
  validates :billing_address_one , :presence => true
  validates :billing_city, :presence => true
  validates :billing_state, :presence => true
  validates :billing_zip, :presence => true
  validates :billing_country, :presence => true

  validates :card_num, :presence => true
  validates :cvv, :presence => true
  validates :card_type, :presence => true
  validates :holder_name, :presence => true
  validates :expiry_date, :presence => true

  include ActiveMerchant::Billing

  def self.testdoDirect(remote_ip)
    gateway = ActiveMerchant::Billing::PaypalGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    response = gateway.purchase(100, '82S16460NC118591H',:ip=>remote_ip)

    #~ gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    #~ response = gateway.purchase(100, '35G12492K3194493X')
    #~ response = gateway.purchase(500,  :ip=>remote_ip, :payer_id => "VMYXUYDC4VENN",:token => "EC-1CJ26925UG460142J")

  end

  def self.doDirectPayment(remote_ip,amount_val,transaction_id)
    gateway = ActiveMerchant::Billing::PaypalGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)
    response = gateway.purchase(amount_val, transaction_id,:ip=>remote_ip)
  end

  def self.payment_with_old_transaction(user_id,user_type,remote_ip,amount_val,consider_promo_payment)
    if user_type == "job_seeker"
      _payment_obj , _promo_obj =  self.job_seeker_old_payment_obj(user_id,consider_promo_payment)
    else
      _payment_obj , _promo_obj = self.employer_old_payment_obj(user_id,consider_promo_payment)
    end

    if _payment_obj.blank?
      return false,Payment.new,nil
    else
      if _promo_obj.blank?
        reference_code = _payment_obj.id_billing_agreement.blank? ? _payment_obj.id_of_transaction : _payment_obj.id_billing_agreement
        return self.doDirectPayment(remote_ip,amount_val * 100,reference_code),_payment_obj,nil
      else
        return true,_payment_obj,_promo_obj
      end
    end
  end

  def self.job_seeker_old_payment_obj(user_id,consider_promo_payment)
  
    latest_payment_obj =  Payment.where("job_seeker_id = ? and payment_mode IS NOT NULL", user_id).order("created_at ASC").last


    if consider_promo_payment == true and !latest_payment_obj.blank? and latest_payment_obj.payment_mode == $payment_mode[:promo_code]

      _payment_obj = Payment.where("job_seeker_id = ? AND payment_mode='#{$payment_mode[:promo_code]}'", user_id).order("created_at ASC").last

      if !_payment_obj.blank? and !_payment_obj.promotional_code_id.blank?
        _promo_obj = PromotionalCode.find(:first,:conditions=>["id = ?",_payment_obj.promotional_code_id])
        if _promo_obj.amount.to_f > _promo_obj.consumed_amount.to_f
          return _payment_obj,_promo_obj
        end
      end
    end

    _payment_obj = Payment.where("job_seeker_id = ? and (
        (id_of_transaction IS NOT NULL AND payment_mode IN ('#{$payment_mode[:pro]}','#{$payment_mode[:pro_promo]}'))
        OR
         (id_billing_agreement IS NOT NULL AND payment_mode IN('#{$payment_mode[:express]}','#{$payment_mode[:express_promo]}')))",user_id).order("created_at ASC").last
    return _payment_obj,nil
  end

  def self.employer_old_payment_obj(user_id,consider_promo_payment)
    latest_payment_obj =  Payment.where("employer_id = ? and payment_mode IS NOT NULL", user_id).order("created_at ASC").last

    if consider_promo_payment == true and !latest_payment_obj.blank? and latest_payment_obj.payment_mode == $payment_mode[:promo_code]
      _payment_obj = Payment.find(:first,:conditions=>["employer_id = ? AND payment_mode = '#{$payment_mode[:promo_code]}'", user_id],:order => "created_at DESC")

      if !_payment_obj.blank? and !_payment_obj.promotional_code_id.blank?
        _promo_obj = PromotionalCode.find(:first,:conditions=>["id = ?",_payment_obj.promotional_code_id])
        if _promo_obj.amount.to_f > _promo_obj.consumed_amount.to_f
          return _payment_obj,_promo_obj
        end
      end
    end
    logger.info("**********query")
    _payment_obj = Payment.where("employer_id = ? and (
             (id_of_transaction IS NOT NULL AND payment_mode IN ('#{$payment_mode[:pro]}','#{$payment_mode[:pro_promo]}'))
             OR
             (id_billing_agreement IS NOT NULL AND payment_mode IN('#{$payment_mode[:express]}','#{$payment_mode[:express_promo]}')))",user_id).order("created_at ASC").last

    return _payment_obj,nil
  end

  def make_payment(remote_ip)
    payment_error = ""
    payment_status  = false
    _verified_obj = nil
    billing_address = {
      :name     => self.holder_name,
      :address1 => self.billing_address_one,
      :address2 => self.billing_address_two,
      :city     => self.billing_city,
      :state    => self.billing_state,
      :country  => self.billing_country,
      :zip      => self.billing_zip
    }

    creditcard = ActiveMerchant::Billing::CreditCard.new(
      :type       => self.card_type,
      :number     => self.card_num,
      :month      => self.expiry_date.split("/")[0].to_s,
      :year       => self.expiry_date.split("/")[1].to_s,
      :verification_value => self.cvv,
      :first_name => self.holder_name.split(" ")[0].to_s,
      :last_name  => self.holder_name.split(" ")[1].to_s

    )

    self.card_number =  self.card_num.to_s.strip.last(4)
    self.card_type = self.card_type
    if creditcard.valid?
      # Create a gateway object to the Paypal service
      gateway = ActiveMerchant::Billing::PaypalGateway.new(:login => $PAYPAL_API_LOGIN, :password => $PAYPAL_API_PASSWORD,:signature => $PAYPAL_API_KEY)

      # Authorize for 10 dollars (1000 cents)

      _amount_to_carge = (self.paypal_amount.to_f * 100.00).ceil

      response = gateway.authorize(_amount_to_carge, creditcard,:ip=>remote_ip , :billing_address=>billing_address)

      if response.success?

        # Capture the money right away
        _verified_obj = gateway.capture(_amount_to_carge, response.authorization, :comment1 => "aaaaaaaa")
        if _verified_obj.params['ack'] == "Success"
          payment_status = true
        end
      else

        #raise StandardError, response.message
        payment_error = response.message
      end
    else
      payment_error = "Invalid credit card information"
    end
    return payment_status,payment_error,_verified_obj
  end

  def set_values_after_pro_payment_success(paypal_verified_object,payment_purpose,mode)
    self.id_of_transaction = paypal_verified_object.params['transaction_id']
    self.paypal_status = paypal_verified_object.params['payment_status']
    self.payment_purpose = payment_purpose
    self.payment_mode = mode
    self.payment_success = true
  end

end
