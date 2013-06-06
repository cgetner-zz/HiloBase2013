# coding: UTF-8
# Important Note: Please don't run this command on the fresh machine or on the fresh server.

namespace :promo_code_balance_handling do
    desc "Handling of Promo Code Balance Amount "
    task(:data => :environment) do

    def promo_code_balance_handling
      @promo = PromotionalCode.where("job_seeker_id IS NOT NULL and amount > consumed_amount and origination = 'beta_code_request'").all
      @promo.each{|promo|
        credit = Credit.where("job_seeker_id = #{promo.job_seeker_id}").first
        if credit.nil?
          credit = Credit.create({:job_seeker_id => promo.job_seeker_id})
        end
        credit.credit_value = credit.credit_value + (promo.amount - promo.consumed_amount)
        credit.save
        promo.update_attributes(:consumed_amount => promo.amount)
      }
    end

    promo_code_balance_handling()
    end
end