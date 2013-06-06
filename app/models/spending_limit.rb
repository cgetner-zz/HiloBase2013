class SpendingLimit < ActiveRecord::Base
   attr_accessible :employer_id, :spend_limit, :setter_id, :available_balance
   
   belongs_to :employer

  def self.consumed_save(e_id)
    emp_spend = SpendingLimit.where(:employer_id => e_id).last
    SpendingLimit.create(:employer_id => e_id, :spend_limit => emp_spend.spend_limit, :setter_id => e_id, :available_balance => emp_spend.available_balance - PURCHASE_PROFILE_COST)
  end
end
