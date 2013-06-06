# coding: UTF-8

namespace :add_company_id_to_referral_fee_table do
  desc "Add company_id to referral fee table"
  task(:data => :environment) do
    
	def add_company_id      
		ReferralFee.where(:company_id=>nil).each do |p|
      job = Job.find_by_id(p.job_id)
      p.company_id = job.company_id
      p.save
		end
	end
    
	add_company_id()
  end
end