# coding: UTF-8

class AccessCodeController < ApplicationController
  layout false
  
  def send_email
    @coderequest = Coderequest.new(params[:coderequest])
      
    employer = Employer.where("email = ?", @coderequest.email).first
    if !employer.nil?
      @error_json = {}
      respond_to do |wants|
        wants.js {render 'send_email_failure', :formats=>[:js]}
      end
      #      render :update do |page|
      #        page.call "access_code.err_on_sending_email", error
      #        if params[:cant_find_promo]
      #          page.call "access_code.set_retry"
      #        end
      #      end
      return
    end
    
    if save_code_request()
      #      render :update do |page|
      #        page.call "access_code.success_msg"
      #      end
      respond_to do |format|
        format.js {render 'send_email_success', :formats=>[:js]}
      end
    else
      #      render :update do |page|
      #        page.call "access_code.err_on_sending_email",@error_json
      #      end
      respond_to do |format|
        format.js {render 'send_email_failure', :formats=>[:js]}
      end
    end
    
  end

  def resend_email
    @coderequest = Coderequest.where("email = ?",params[:coderequest][:email]).first
    if not @coderequest.nil?
      employer = Employer.where("email = ?", @coderequest.email).first
      if !employer.nil?
        @error_json = {}
        respond_to do |wants|
          wants.js {render 'send_email_failure', :formats => [:js]}
        end
        #        render :update do |page|
        #          page.call "access_code.err_on_sending_email", error
        #          if params[:cant_find_promo]
        #            page.call "access_code.set_retry"
        #          end
        #        end
        return
      else
        promo_code = PromotionalCode.select("code").where("id= ?", @coderequest.promotional_code_id).first
        Notifier.code_request( @coderequest.email,promo_code,request.env["HTTP_HOST"]).deliver
        respond_to do |format|
          format.js {render 'send_email_success', :formats => [:js]}
        end
        #        render :update do |page|
        #          page.call "access_code.success_msg"
        #          if params[:cant_find_promo]
        #            page.call "access_code.set_success"
        #          end
        #        end
      end
    else
      @coderequest = Coderequest.new(params[:coderequest])
      if save_code_request()
        respond_to do |format|
          format.js {render 'send_email_success', :formats => [:js]}
        end
        #        render :update do |page|
        #          page.call "access_code.success_msg"
        #          if params[:cant_find_promo]
        #            page.call "access_code.set_success"
        #          end
        #        end
      else
        respond_to do |wants|
          wants.js {render 'send_email_failure', :formats => [:js]}
        end
        #        render :update do |page|
        #          page.call "access_code.err_on_sending_email",@error_json
        #          if params[:cant_find_promo]
        #            page.call "access_code.set_retry"
        #          end
        #        end
      end
    end
  end
  
  private
  
  def save_code_request
    if @coderequest.save
      promo_code = PromotionalCode.create_random_code(PROMO_COST,$promo_code_origination[:beta_code_request])
      @coderequest.promotional_code_id = promo_code.id
      @coderequest.save(:validate => false)
      Notifier.code_request( @coderequest.email,promo_code,request.env["HTTP_HOST"]).deliver
      session['beta_email']=@coderequest.email
      return true
    else
      @coderequest.errors.each{|k,v|
        @error_arr << [k,v]
      }
      @error_json = json_from_error_arr(@error_arr )
      return false
    end
  end
 
end
