# coding: UTF-8

namespace :update_company_id_in_company_groups do
  desc "Update company_id in company_groups"
  task(:data => :environment) do
    
	def update_company_id
		CompanyGroup.all.each do |cg|
			cg.company_id = cg.employer.company_id
			cg.save(:validate=>false)
		end
	end
    
	update_company_id()
  end
end