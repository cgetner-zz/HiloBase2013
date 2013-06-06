class RemoveOverviewFromJob < ActiveRecord::Migration
  def up
    jobs = Job.all
    jobs.each do |job|
      job.summary = job.overview.to_s + " " + job.summary.to_s
      job.save(:validate=>false)
    end
    remove_column :jobs, :overview
  end
end
