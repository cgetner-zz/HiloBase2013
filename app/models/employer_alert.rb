# coding: UTF-8

class EmployerAlert < ActiveRecord::Base
  attr_accessible :job_seeker_id, :employer_id, :job_id, :purpose, :read, :deleted_employer_id, :new, :employer_job_activity, :company_group_id
  
  belongs_to :employer
  #belongs_to :job

  def self.cron_daily_generate_employer_email_notifications
    employers = Employer.where("request_deleted = #{false} AND alert_method = ?", DAILY_EMAIL).all
    for emp in employers
      alerts = EmployerAlert.select("*").where("employer_id = ? and employer_alerts.created_at BETWEEN ? and ? ", emp.id, DateTime.now.utc - 1, DateTime.now.utc).all

      email_hash = {:employer_first_name => emp.first_name, :employer_email => emp.email, :employer_alerts => alerts.map{|m| m.id}}
      
      if !alerts.blank?
        Notifier.email_employer_notifications(email_hash).deliver
        emp.notification_email_time = DateTime.now
        emp.save(:validate => false)
      end
    end
  end

  def self.cron_weekly_generate_employer_email_notifications
    employers = Employer.where("request_deleted = #{false} AND alert_method = ?", WEEKLY_EMAIL).all
    for emp in employers
      alerts = EmployerAlert.select("*").where("employer_id = ? and employer_alerts.created_at BETWEEN ? and ?", emp.id, DateTime.now.utc - 7, DateTime.now.utc).all

      email_hash = {:employer_first_name => emp.first_name, :employer_email => emp.email, :employer_alerts => alerts.map{|m| m.id}}

      if !alerts.blank?
        Notifier.email_employer_notifications(email_hash).deliver
        emp.notification_email_time = DateTime.now
        emp.save(:validate => false)
      end
    end
  end
end
