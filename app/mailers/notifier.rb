# coding: UTF-8

class Notifier < ActionMailer::Base
  default from: "\"The Hilo Project\" <info@thehiloproject.com>"

  def send_summary(jobs_active_count, jobs_deleted_count, jobs_inactive_count, jobs_failed_count)
    @headers =
    {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @jobs_active_count = jobs_active_count
    @jobs_deleted_count = jobs_deleted_count
    @jobs_inactive_count = jobs_inactive_count
    @jobs_failed_count = jobs_failed_count

    if Rails.env.to_s == "production"
      email = "chris@thehiloproject.com"
      mail_subject = "Job Wrapping Summary"
    else
      email = "swati.joshi@globallogic.com"
      mail_subject = "[Staging] Job Wrapping Summary"
    end
    mail(:subject => "#{mail_subject} - #{Date.today}",
      :to => email,
      :cc => "hilo@globallogic.com",
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def password_reset(email, first_name, last_name, fpwd_code)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => email
    }
    @fpwd_code = fpwd_code
    @first_name = first_name
    @last_name = last_name
    mail(:subject => "Hilo Account Access Confirmation",
      :to => email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def delete_single(emp)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => emp.email
    }
    @emp = emp
    mail(:subject => "Hilo Account Deletion",
      :to => emp.email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def delete_root(emp)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => emp.email
    }
    @emp = emp
    mail(:subject => "Hilo Account Deletion",
      :to => emp.email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def delete_child(emp)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => emp.email
    }
    @emp = emp
    mail(:subject => "Hilo Account Deletion",
      :to => emp.email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def new_root(emp)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => emp.email
    }
    @emp = emp
    mail(:subject => "New Role as Root User",
      :to => emp.email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def delete_seeker(js)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => js.email
    }
    @js = js
    mail(:subject => "Hilo Account Deletion",
      :to => js.email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def ics_convert(js)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => js.email
    }
    @js = js
    mail(:subject => "Hilo Account Conversion",
      :to => js.email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end
  
  def invitation_ics_phase_two(email, company_name, link)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => email
    }
    @company_name = company_name
    @link = link
    mail(:subject => "Hilo Account Access",
      :to => email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end
  
  def email_employer_notifications(args_hash)
    #alerts = EmployerAlert.select("*").joins("join jobs on jobs.id = employer_alerts.job_id").where("employer_alerts.id = ?", args_hash[:employer_alerts])
    emp = Employer.find_by_email(args_hash[:employer_email])
    alerts = EmployerAlert.select("company_groups.name AS folder_name, company_groups.employer_id, jobs.name, job_seekers.id as job_seeker_id, job_seekers.first_name, job_seekers.last_name,employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.employer_id AS emp_id, employer_alerts.job_id, employer_alerts.deleted_employer_id,employer_alerts.id, employer_alerts.employer_job_activity, employer_alerts.company_group_id, employer_alerts.created_at AS created_at")
    .joins("LEFT JOIN jobs ON employer_alerts.job_id = jobs.id LEFT JOIN job_seekers ON employer_alerts.job_seeker_id = job_seekers.id LEFT JOIN company_groups ON employer_alerts.employer_id = company_groups.old_employer_id")
    .where("employer_alerts.id IN (?) AND (jobs.employer_id IN (?) OR jobs.employer_id IS NULL OR jobs.old_employer_id = ?) AND employer_alerts.purpose <> ? AND employer_alerts.employer_id = ? OR (company_groups.old_employer_id = #{emp.id} AND company_groups.old_employer_id IS NULL)", args_hash[:employer_alerts], emp.subtree_ids, emp.id, "consider", emp.id)
    employer_email = args_hash[:employer_email]
    @headers =
      {
      'return-path' => 'The Hilo Project <info@thehiloproject.com>',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => employer_email
    }
    @alerts = alerts
    @employer_name = args_hash[:employer_first_name]
    mail(:subject => "Position Alert from TheHiloProject.com",
      :to => employer_email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def email_job_seeker_notifications(job_seeker, alerts)
    @headers =
      {
      'return-path' => 'The Hilo Project <info@thehiloproject.com>',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @alerts = alerts
    @job_seeker = job_seeker
    mail(:subject => "Position Alert from TheHiloProject.com",
      :to => job_seeker.email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def email_save_and_return_later(receiver, host_name)
    @headers =
    {
      'return-path' => 'The Hilo Project <info@thehiloproject.com>',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @receiver = receiver
    @host_name = host_name
    mail(:subject => "Position Alert from TheHiloProject.com",
      :to => receiver.email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
                format.html
               end
  end
  
  def gift_card_mail(gift,pc_obj,host_name)
    @headers = 
      {
      'return-path' => 'The Hilo Project <info@thehiloproject.com>',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => gift.recipient_email
    }
    @gift = gift
    @pc_obj = pc_obj
    @host_name = host_name
    mail(:subject => "#{gift.sender_name} has sent you a The Hilo Project Gift", 
      :to => gift.recipient_email, 
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end
  
  def gift_card_sender(gift,id_transaction,host_name)
    @headers = 
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => gift.sender_email
    }
    @gift = gift
    @host_name = host_name
    @id_transaction = id_transaction
    mail(:subject => "Hilo Gift Receipt", 
      :to => gift.sender_email, 
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def reset_password_link(email,fpwd_code,host_name)
    @headers = 
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => email
    }
    @host_name = host_name
    @fpwd_code = fpwd_code
    mail(:subject => "Hilo Password Reset", 
      :to => email, 
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def code_request(email,pc_obj,host_name)
    @headers = 
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => email
    }
    @pc_obj = pc_obj
    @host_name = host_name
    mail(:subject => "Your Hilo Access Code", 
      :to => email, 
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def guest_job_seeker_promo_code_mail(email,pc_code,host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => email
    }
    @pc_code = pc_code
    @host_name = host_name
    mail(:subject => "Give Hilo a Try!",
      :to => email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def account_create(email, first_name, credit, discount, company_name, host_name, ics_type)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @first_name = first_name
    @credit = credit
    @discount = discount
    @host_name = host_name
    @company_name = company_name
    @ics_type = ics_type
    @email = email
    mail(:subject => "Welcome to The Hilo Project",
      :to => email,
      :from => "\"The Hilo Project\" <info@thehiloproject.com>",
      :date => Time.now) do |format|
      format.html
    end
  end

  def corporate_account_request(corporate_account_email, host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @host_name = host_name
    mail(:subject => "Your Account Request Has Been Received",
        :to => corporate_account_email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def new_corporate_account_request(host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @host_name = host_name
    mail(:subject => "New Corporate Account Request",
        :to => "info@thehiloproject.com",
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def admin_delete_notification(type, obj, host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @host_name = host_name
    @type = type
    @obj = obj
    mail(:subject => "New Account Deletion Request",
        :to => "info@thehiloproject.com",
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def admin_delete_cancel(obj, host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @host_name = host_name
    @obj = obj
    mail(:subject => "Delete Request Cancelled",
        :to => obj.email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def welcome_employer(employer_email, password, host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @email = employer_email
    @password = password
    @host_name = host_name
    mail(:subject => "Your Hilo Account is Ready!",
        :to => @email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def welcome_new_administrator(admin_email, password, host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @email = admin_email
    @password = password
    @host_name = host_name
    mail(:subject => "New Account Privileges",
        :to => @email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def welcome_new_sub_user(user_email, password, host_name, sender_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @email = user_email
    @password = password
    @host_name = host_name
    @sender_name = sender_name
    mail(:subject => "Welcome to Hilo!",
        :to => @email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def mail_to_deleted_user(user_email, sender_name, host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @email = user_email
    @sender_name = sender_name
    @host_name = host_name
    mail(:subject => "Hilo Account Removal",
        :to => @email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def mail_to_suspended_user(user_email, sender_name, host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @email = user_email
    @sender_name = sender_name
    @host_name = host_name
    mail(:subject => "Hilo Account Suspension",
        :to => @email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def mail_to_reinstate_user(user_email, host_name)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @email = user_email
    @host_name = host_name
    mail(:subject => "Hilo Account Restored",
        :to => @email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

  def remind_not_logged_js(js_obj_email)
    @headers =
      {
      'return-path' =>  'info@thehiloproject.com',
      'X-Special-Domain-Specific-Header' => "SecretValue",
      'In-Reply-To' => 'info@thehiloproject.com'
    }
    @email = js_obj_email
    mail(:subject => "New Opportunities at TheHiloProject.com",
        :to => @email,
        :from => "\"The Hilo Project\" <info@thehiloproject.com>",
        :date => Time.now) do |format|
          format.html
        end
  end

# TO BE USED LATER ON
#  def administrator_login
#    @headers =
#      {
#      'return-path' =>  'info@thehiloproject.com',
#      'X-Special-Domain-Specific-Header' => "SecretValue",
#      'In-Reply-To' => 'ravi.asnani@globallogic.com'
#    }
#    mail(:subject => "HILO | Administrator Account",
#      :to => "ravi.asnani@globallogic.com",
#      :from => "info@thehiloproject.com",
#      :date => Time.now) do |format|
#      format.html
#    end
#  end
#
#  def administrator_login_failure
#    @headers =
#      {
#      'return-path' =>  'info@thehiloproject.com',
#      'X-Special-Domain-Specific-Header' => "SecretValue",
#      'In-Reply-To' => 'ravi.asnani@globallogic.com'
#    }
#    mail(:subject => "HILO | Administrator Account",
#      :to => "ravi.asnani@globallogic.com",
#      :from => "info@thehiloproject.com",
#      :date => Time.now) do |format|
#      format.html
#    end
#  end

end