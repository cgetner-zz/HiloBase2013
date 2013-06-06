# coding: UTF-8
# Important Note: Don't run this command on a fresh machine or on a fresh server. This command has already run as a part of the previous release.

namespace :deactivate_jobs do
    desc "Handling of legacy data for employer jobs"
    task(:data => :environment) do
    def deactivate_jobs
      @jobs = Job.where(:active=>true,:deleted => false).all
      @jobs.each{|job|
        job.profile_complete = false
        job.active = false
        job.overview_complete = false
        job.detail_preview = false
        job.credential_complete = false
        job.deactivated_for_new_credential = false
        job.save(:validate=>false)
      }
      @jobs = Job.where("deactivated_for_new_credential is null").all
      @jobs.each{|job|
        job.profile_complete = false
        job.active = false
        job.overview_complete = false
        job.detail_preview = false
        job.credential_complete = false
        job.save(:validate=>false)
      }
    end
    deactivate_jobs()
    end
end