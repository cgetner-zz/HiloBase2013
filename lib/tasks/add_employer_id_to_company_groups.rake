# coding: UTF-8
# Important Note: Please don't run this command on the fresh machine or on the fresh server. This task has already ran as a part of previous release.

namespace :add_employer_id_to_company_groups do
  desc "Add employer_id to company_groups"
  task(:data => :environment) do
    
	def add_employer_id      
		CompanyGroup.all.each do |cg|
			cg.employer_id = Employer.where(:company_id=>cg.company_id).first.id
			cg.save(:validate=>false)
		end
	end
    
	add_employer_id()
  end
end