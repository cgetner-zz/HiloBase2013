# coding: UTF-8

namespace :add_company_id_to_purchased_profiles do
  desc "Add company_id to purchased_profiles"
  task(:data => :environment) do
    
	def add_company_id      
		PurchasedProfile.all.each do |p|
			p.company_id = Employer.find(p.employer_id).company_id
			p.save
		end
	end
    
	add_company_id()
  end
end