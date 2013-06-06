class Credit < ActiveRecord::Base
  attr_accessible :job_seeker_id, :credit_value
  belongs_to :job_seeker

  def self.consumed_save(total_amount, job_seeker_id)
    credit = Credit.where(:job_seeker_id => job_seeker_id).first
    if not credit.nil?
      credit.credit_value = credit.credit_value - total_amount.to_f
      credit.save
    end
  end
end
