# coding: UTF-8

class JobSeekerNotification < ActiveRecord::Base
  belongs_to :job_seeker
  belongs_to :notification_message
  belongs_to :notification_type
  belongs_to :job
  belongs_to :company

  attr_accessible :job_seeker_id, :job_id, :notification_type_id, :notification_message_id, :visibility, :company_id

  def self.cron_daily_generate_job_seeker_email_notifications
   job_seekers = JobSeeker.where("request_deleted = #{false} AND alert_method = ?", DAILY_EMAIL)
    for js in job_seekers
      alerts = JobSeekerNotification.select("*").where("job_seeker_id = #{js.id} and created_at BETWEEN ? and ?", DateTime.now.utc-1, DateTime.now.utc).all
      if !alerts.blank?
        Notifier.email_job_seeker_notifications(js, alerts).deliver
        js.notification_email_time = DateTime.now
        js.save(:validate => false)
      end
    end
  end

  def self.cron_weekly_generate_job_seeker_email_notifications
   job_seekers = JobSeeker.where("request_deleted = #{false} AND alert_method = ?", WEEKLY_EMAIL)
    for js in job_seekers
      alerts = JobSeekerNotification.select("*").where("job_seeker_id = #{js.id} and created_at BETWEEN ? and ?", DateTime.now.utc-7, DateTime.now.utc).all
      if !alerts.blank?
        Notifier.email_job_seeker_notifications(js, alerts).deliver
        js.notification_email_time = DateTime.now
        js.save(:validate => false)
      end
    end
  end
end
