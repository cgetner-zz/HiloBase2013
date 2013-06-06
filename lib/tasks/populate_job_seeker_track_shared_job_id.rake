# coding: UTF-8

namespace :populate_job_seeker_track_shared_job_id do
    desc "Populate JobSeeker's track_shared_job_id from ReferralFee's job_id"
    task(:data => :environment) do
    def populate 
      referral_fees = ReferralFee.all
      referral_fees.each{|referral_fee|
          job_seeker = JobSeeker.where(:id => referral_fee.job_seeker_id).first
          job_seeker.update_attributes(:track_shared_job_id => referral_fee.job_id)
      }
    end

    def populate_job_seeker_notification
      js_notify = JobSeekerNotification.select("job_seeker_id, job_id").where("notification_type_id = 3 and (notification_message_id IN (7,8))").all
      js_notify.each{|js_note|
        job_seeker = JobSeeker.where(:id => js_note.job_seeker_id).first
        job_seeker.update_attributes(:track_shared_job_id => js_note.job_id)
      }
    end
    populate()
    populate_job_seeker_notification()
    end
end