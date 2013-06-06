# coding: UTF-8

namespace :populate_hiring_company do
  desc "Populate Hiring Company"
  task(:data=> :environment) do
    def populate_hiring_company
      jobs = Job.where('hiring_company = ?',1).all
      if not jobs.nil?
        for job in jobs
          if not job.company.nil?
            job.hiring_company_name = job.company.name
          end
          job.save(:validate=>false)
        end
      end
    end
    populate_hiring_company()
    
  end
end
