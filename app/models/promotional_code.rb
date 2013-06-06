# coding: UTF-8

class PromotionalCode < ActiveRecord::Base

    attr_accessible :code, :amount, :given, :consumed_amount, :origination, :job_seeker_id
    belongs_to :gift
    
    def self.valid_code_for_employer(code_val,id_employer=nil)
        if id_employer.nil?
            _pc = PromotionalCode.find(:first,:conditions=>["code = ? AND job_seeker_id IS NULL AND employer_id IS NULL and given = ? AND amount > consumed_amount",code_val,true])
        else
            _pc = PromotionalCode.find(:first,:conditions=>["code = ? and given = ? AND amount > consumed_amount AND ((job_seeker_id IS NULL AND employer_id IS NULL) OR employer_id = ?)",code_val,true,id_employer])
        end
        return _pc  
    end
    
    def self.valid_code_for_seeker(code_val,id_seeker=nil)
        if id_seeker.nil?
            _pc = PromotionalCode.where("code = ? AND job_seeker_id IS NULL AND employer_id IS NULL and given = ? AND (amount > consumed_amount OR consumed_amount IS NULL)",code_val,true).first
        else
            _pc = PromotionalCode.find(:first,:conditions=>["code = ? and given = ? AND (amount > consumed_amount OR consumed_amount IS NULL) AND ((job_seeker_id IS NULL AND employer_id IS NULL) OR job_seeker_id = ?)",code_val,true,id_seeker])
        end
        return _pc  
    end
      
    def amount_after_deduction(chargeable_amount)
        total_amount = chargeable_amount
        paypal_amount = chargeable_amount
        promotional_code_amount = 0.00
        promotional_remaining_amt = 0.00
        if self.amount > self.consumed_amount
            if((self.amount - self.consumed_amount)*100).round.to_f / 100 >=  chargeable_amount
                  paypal_amount = 0.00
                  promotional_code_amount = chargeable_amount
            else
                  promotional_code_amount = ((self.amount - self.consumed_amount)*100).round.to_f / 100
                  paypal_amount = total_amount.to_f - promotional_code_amount.to_f
            end
        end
        promotional_remaining_amt = self.amount - (self.consumed_amount + promotional_code_amount)
        return  total_amount, paypal_amount , promotional_code_amount,promotional_remaining_amt
    end
    
    def self.create_random_code(amt_val, origination="")
      code_val = (0...10).map{65.+(rand(25)).chr}.join
      obj = self.new({:code => code_val,:given => true,:amount => amt_val,:origination => origination})
      obj.save(:validate => false)
      obj.code = obj.code + obj.id.to_s
      obj.save(:validate => false)
      return obj
    end

    def self.create_random_code_site_activation(amt_val, origination="", seeker_id)
      code_val = (0...10).map{65.+(rand(25)).chr}.join
      obj = self.new({:code => code_val,:given => true,:amount => amt_val, :consumed_amount => amt_val, :origination => origination, :job_seeker_id => seeker_id})
      obj.save(:validate => false)
      obj.code = obj.code + obj.id.to_s
      obj.save(:validate => false)
    end

    def self.create_random_code_admin_site_activation(amt_val, origination="", seeker_id)
      code_val = (0...10).map{65.+(rand(25)).chr}.join
      obj = self.new({:code => code_val, :given => true, :amount => amt_val, :consumed_amount => 0, :origination => origination, :job_seeker_id => seeker_id})
      obj.save(:validate => false)
      obj.code = obj.code + obj.id.to_s
      obj.save(:validate => false)
      return obj
    end
    
    def self.consumed_save(promotional_code_id,promotional_code_amount,user_type= nil,user_id=nil)  
        promotional_code = PromotionalCode.where("id = ?",promotional_code_id).first
        if not promotional_code.blank?
            if user_type == "job_seeker"
                promotional_code.job_seeker_id = user_id
            elsif user_type == "employer"
                promotional_code.employer_id = user_id
            end
            
            promotional_code.consumed_amount = promotional_code.consumed_amount.to_f + promotional_code_amount.to_f
            promotional_code.save(:validate => false)
        end
    end
    
end
