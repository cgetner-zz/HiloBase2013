# coding: UTF-8

class JobStatus < ActiveRecord::Base
  attr_accessible :job_id, :job_seeker_id, :read, :considering
  after_save :create_employer_alerts
  acts_as_paranoid

  belongs_to :job_seeker
  belongs_to :job

  before_destroy :send_notification_to_job_seeker

  def send_notification_to_job_seeker
    #Notification to job seeker who had applied for this position
    logger.info "*************************JobStatus id***********#{self.inspect}"
    if self.interested == true or self.wild_card == true
      #when job is getting deleted
      logger.info "****************active**********#{self.job.active}"
      logger.info "****************deleted******************#{self.job_seeker.deleted}"
      if self.job.active == true and self.job_seeker.deleted == false
        alert = JobSeekerNotification.create(:job_seeker_id => self.job_seeker_id, :job_id => self.job_id, :notification_type_id => 3, :notification_message_id => 13, :visibility => true, :company_id => self.job.company_id)
        job_seeker = JobSeeker.where(:id => self.job_seeker_id).first
        if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
          Notifier.email_job_seeker_notifications(job_seeker, alert).deliver
          job_seeker.notification_email_time = DateTime.now
          job_seeker.save(:validate => false)
        end
      end
    end
  end
  
  ##RSPEC: Can't be tested
  def create_employer_alerts
    job_status = JobStatus.where("job_seeker_id = ? and job_id = ?",job_seeker_id,job_id).first
    employer_alerts = EmployerAlert.where("job_seeker_id = ? and job_id = ?",job_seeker_id,job_id).all
    employer_id = Job.find(job_status.job_id).employer_id
    check_and_create_notification(job_status, employer_alerts, employer_id)

    employer = Employer.find_by_id(employer_id)
    all_parent_employers = employer.ancestors
    all_parent_employers.each do |parent_employer|
      check_and_create_notification(job_status, employer_alerts, parent_employer.id)
    end
  end

  def check_and_create_notification(job_status, employer_alerts, employer_id)
    if job_status.wild_card == true
      create_notification = true
      for emp_alert in employer_alerts
        if emp_alert.purpose == "wild_card" and emp_alert.employer_id == employer_id
          create_notification = false
        end
      end
      if create_notification == true
        employer_alerts = EmployerAlert.create({:job_seeker_id =>job_status.job_seeker_id,:job_id => job_status.job_id,:purpose =>"wild_card",:read => "false", :employer_id=>employer_id})
        #alert method
        employer = Employer.find(employer_id)
        if employer.alert_method == ON_EVENT_EMAIL  and !employer.request_deleted
          email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
          Notifier.email_employer_notifications(email_hash).deliver
          employer.notification_email_time = DateTime.now
          employer.save(:validate => false)
        end
      end
    end

    if job_status.interested == true
      create_notification = true
      for emp_alert in employer_alerts
        if emp_alert.purpose == "interested" and emp_alert.employer_id == employer_id
          create_notification = false
        end
      end
      if create_notification == true
        employer_alerts= EmployerAlert.create({:job_seeker_id =>job_status.job_seeker_id,:job_id => job_status.job_id,:purpose =>"interested",:read => "false", :employer_id=>employer_id})
        #alert method
        employer = Employer.find(employer_id)
        if employer.alert_method == ON_EVENT_EMAIL and !employer.request_deleted
          email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
          Notifier.email_employer_notifications(email_hash).deliver
          employer.notification_email_time = DateTime.now
          employer.save(:validate => false)
        end
      end
    end

  end

  ##RSPEC: Can't be tested
  def self.change_job_status(id_job,seeker_id,status_type)
    job_status = JobStatus.where("job_seeker_id = ? and job_id = ?",seeker_id,id_job).first
    #job_status = JobStatus.new({:job_seeker_id =>seeker_id,:job_id => id_job }) if job_status.blank?
    if job_status.blank?
      job_status = JobStatus.new({:job_seeker_id =>seeker_id,:job_id => id_job })
    end

    #c = Job.where(:id=>id_job).first.company_id
    
    case status_type
    when "consider"
      if !job_status.considering
#        BroadcastController.new.delay(:priority => 6).detailed_position(id_job)
        employer = Job.find(id_job).employer
#        employer.ancestor_ids.each do |emp_id|
#          BroadcastController.new.delay(:priority => 6).xref_detailed(emp_id)
#        end
#        BroadcastController.new.delay(:priority => 6).xref_detailed(employer.id)

        BroadcastController.new.employer_update(employer.company_id, "candidate_pool", [id_job])
        BroadcastController.new.employer_update(employer.company_id, "xref", [id_job], [seeker_id])
      end
      job_status.considering = true
      job_status.considered_on = Time.now
      #              job_status_new.considering = true
      #              job_status_new.considered_on = Time.now
    when "interest", "interest_excluded"
      if !job_status.interested
#        BroadcastController.new.delay(:priority => 6).applied_position(id_job)
        employer = Job.find(id_job).employer
#        employer.ancestor_ids.each do |emp_id|
#          BroadcastController.new.delay(:priority => 6).xref_applied(emp_id)
#        end
#        BroadcastController.new.delay(:priority => 6).xref_applied(employer.id)


        BroadcastController.new.employer_update(employer.company_id, "candidate_pool", [id_job])
        BroadcastController.new.employer_update(employer.company_id, "xref", [id_job], [seeker_id])
      end
      job_status.interested = true
      job_status.interested_on = Time.now
      #              job_status_new.interested = true
      #              job_status_new.interested_on = Time.now
    when "wild", "wild_excluded"
      job_status.wild_card = true
      job_status.wildcard_on = Time.now
      #              job_status_new.wild_card = true
      #              job_status_new.wildcard_on = Time.now
    end
       
    job_status.save(:validate => false)
    #       job_status_new.save(:validate => false)
  end
     
  def self.cost_for_purpose(purpose)
    case purpose
    when "consider"
      return JOB_DETAIL_VIEW_COST
    when "interest"
      return JOB_EXPRESS_INTEREST_COST
    when "wild"
      return JOB_WILD_CARD_COST
    end
  end
  
  def set_read
    self.read = true
    self.read_on = Time.now
  end
  
  def set_considering(job_id, seeker_id)
    if !self.considering
#      BroadcastController.new.delay(:priority => 6).detailed_position(job_id)
      employer = Job.find(job_id).employer
#      employer.ancestor_ids.each do |emp_id|
#        BroadcastController.new.delay(:priority => 6).xref_detailed(emp_id)
#      end
#      BroadcastController.new.delay(:priority => 6).xref_detailed(employer.id)

      BroadcastController.new.employer_update(employer.company_id, "candidate_pool", [job_id])
      BroadcastController.new.employer_update(employer.company_id, "xref", [job_id], [seeker_id])
    end
    self.considering = true
    self.considered_on = Time.now
  end
  
end