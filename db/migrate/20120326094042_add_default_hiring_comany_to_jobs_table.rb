# coding: UTF-8

class AddDefaultHiringComanyToJobsTable < ActiveRecord::Migration
  def self.up
	jobs = Job.with_deleted.where('hiring_company = ?',1).all
	if not jobs.nil?
		for job in jobs
			job.hiring_company_name = job.company.name
			job.save(:validate=>false)
		end
	end
  end

  def self.down
	jobs = Job.with_deleted.where('hiring_company = ?',1).all
	if not jobs.nil?
		for job in jobs
			job.hiring_company_name = nil
			job.save(:validate=>false)
		end
	end
  end
end
