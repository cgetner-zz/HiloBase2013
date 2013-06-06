# coding: UTF-8

class PurchasedProfile < ActiveRecord::Base
  
  attr_accessible :employer_id, :job_seeker_id, :payment_id, :job_id, :company_id
  acts_as_paranoid

  belongs_to :payment
  belongs_to :employer
  belongs_to :job_seeker
  belongs_to :company
  belongs_to :job

  def self.seeker_purchased_by_company(job_seeker_id, company_id)
      self.find(:first,:select => "created_at", :conditions=>["job_seeker_id = ? and company_id = ? and payment_id != ?", job_seeker_id, company_id, 0],:order=>"created_at desc")
  end

  def self.log_employer_view(job_id, job_seeker_id, emp_id)
    emp_company_id = Employer.where(:id=>emp_id).first.company_id
    emp_value = PurchasedProfile.find(:all, :conditions => ["job_seeker_id = ? and employer_id = ? and job_id = ?", job_seeker_id, emp_id, job_id])
    if emp_value.blank?
      PurchasedProfile.new({:company_id => emp_company_id, :employer_id => emp_id, :job_seeker_id => job_seeker_id, :payment_id=>"NULL", :job_id => job_id}).save(:validate => false)
    end
  end

  def fit_name_by_pairing
    # Changed for Pairing Logic
    if pairing > 4
      return "Best"
    elsif pairing > 3 and pairing <= 4
      return "Better"
    elsif pairing > 2 and pairing <= 3
      return "Good"
    else
      return "Wildcard"
    end
    #End
  end
  
end
