# coding: UTF-8
require "delayed_job"

class PairingLogic < ActiveRecord::Base
  require 'geocoder'
  acts_as_paranoid
  belongs_to :job
  belongs_to :job_seeker

  #validates :pairing_value, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5 }

  RAD_PER_DEG = 0.017453293
  Rkm = 6378.1598092

  def self.pairing_value_job_seeker(job_seeker)
    pairing_value_job_seeker_jobs(job_seeker)
  end

  def self.pairing_value_job(job, from_where = nil)
    pairing_value_job_job_seekers(job, from_where)
  end

  def self.cron_run_pairing_logic
    activated_seekers = Array.new
    job_seekers = JobSeeker.where("activated = ? AND request_deleted = ?", true, false)
    jobs_count = Job.where("active = ? and internal = ? and deleted = ? and expire_at > ? and grid_work_environment_x !=? and grid_work_environment_y !=? and grid_work_role_x !=? and grid_work_role_y !=? and locked = ?", true, false, false, Time.now,"","","","",false).count
    job_seekers.each do |job_seeker|
      if job_seeker.company_id.nil?
        if(job_seeker.job_seeker_birkman_detail.pdf_saved == true && !job_seeker.job_seeker_birkman_detail.grid_work_environment_x.blank? && !job_seeker.job_seeker_birkman_detail.grid_work_environment_y.blank? && !job_seeker.job_seeker_birkman_detail.grid_work_role_x.blank? && !job_seeker.job_seeker_birkman_detail.grid_work_role_y.blank?)
          if job_seeker.pairing_logics.size < jobs_count
            logger.info("***************************job_seeker#{job_seeker.id}")
            activated_seekers << job_seeker
            if activated_seekers.size == 5
              break
            end
          end
        end
      else
        jobs_internal_count = Job.where("active = ? and internal = ? and company_id IN (#{job_seeker.company.subtree_ids.join(',')}) and deleted = ? and expire_at > ? and grid_work_environment_x !=? and grid_work_environment_y !=? and grid_work_role_x !=? and grid_work_role_y !=? and locked = ?", true, true, false, Time.now,"","","","",true).count
        if(job_seeker.job_seeker_birkman_detail.pdf_saved == true && !job_seeker.job_seeker_birkman_detail.grid_work_environment_x.blank? && !job_seeker.job_seeker_birkman_detail.grid_work_environment_y.blank? && !job_seeker.job_seeker_birkman_detail.grid_work_role_x.blank? && !job_seeker.job_seeker_birkman_detail.grid_work_role_y.blank?)
          if job_seeker.pairing_logics.size < jobs_internal_count
            logger.info("***************************job_seeker_internal#{job_seeker.id}")
            activated_seekers << job_seeker
            if activated_seekers.size == 5
              break
            end
          end
        end
      end

    end
    activated_seekers.each do |job_seeker|
      pairing_value_job_seeker_jobs(job_seeker)
    end
  end

  private

  def self.pairing_value_job_seeker_jobs(job_seeker)
    company_ids = Array.new
    job_ids = Array.new
    if !job_seeker.job_seeker_desired_locations[0].nil?
      if job_seeker.ics_type_id == 4
        job_all = Job.where("active = ? and internal = #{false} and deleted = ? and expire_at > ? and grid_work_environment_x !=? and grid_work_environment_y !=? and grid_work_role_x !=? and grid_work_role_y !=?", true, false, Time.now,"","","","")
      else
        job_all = Job.where("active = ? and company_id IN (#{job_seeker.company.subtree_ids.join(',')}) and deleted = ? and expire_at > ? and grid_work_environment_x !=? and grid_work_environment_y !=? and grid_work_role_x !=? and grid_work_role_y !=?", true, false, Time.now,"","","","")
      end
      pairing_value_arr = []
      for job in job_all
        old_value = job_seeker.pairing_logics.where("job_id = ?", job.id).first
        old_value = old_value.pairing_value unless old_value.nil?
        pair_value = calculate_all_pairing_logic_parameter(job_seeker, job).round(5)
        #save pairing logic
        pairing = PairingLogic.where("job_seeker_id =? and job_id =?", job_seeker.id, job.id).first
        if pairing.nil?
          pairing = PairingLogic.new
        end
        pairing.job_seeker_id = job_seeker.id
        pairing.job_id = job.id
        pairing.pairing_value = pair_value
        pairing.save
        #pairing_value_arr << pairing
        #feed
        if pair_value != old_value
          job_ids<<job.id
          company_ids<<job.company_id
          #          BroadcastController.new.delay(:priority => 6).candidate_update(job.id)
        end
        # employer alert threshold
        employer_threshold(job, job_seeker, pair_value)

        if job_seeker.track_shared_job_id == job.id.to_s and not job_seeker.bridge_response.nil?
          # Generate notifications
          @notification = JobSeekerNotification.new
          @notification.job_seeker_id = job_seeker.id
          @notification.job_id = job.id
          @notification.company_id = job.company.id
          @notification.notification_type_id = 3
          LogJobShare.log_job(job.id, job_seeker.track_platform_id, job_seeker.id)
          if job_seeker.bridge_response == "yes"
            JobSeekerFollowCompany.create({:company_id => job.company.id,:job_seeker_id => job_seeker.id})
            JobSeekerWatchlist.create({:job_id =>job.id,:job_seeker_id => job_seeker.id})
            @notification.notification_message_id = 7
          else
            JobSeekerWatchlist.create({:job_id =>job.id,:job_seeker_id => job_seeker.id})
            @notification.notification_message_id = 8
          end
          @notification.visibility = true
          @notification.save

          job_seeker.bridge_response = nil
          job_seeker.track_platform_id = nil
          job_seeker.save(:validate => false)
        end
      end
      #PairingLogic.import pairing_value_arr, :on_duplicate_key_update => [:pairing_value]
      #feed
      BroadcastController.new.job_seeker(job_seeker.id)

      company_ids.uniq.each do |c|
        #BroadcastController.new.delay(:priority => 6).xref_update(job_seeker.id, c, job_ids)

        #changes to dynamic updates
        BroadcastController.new.employer_update(c, "xref", job_ids, [job_seeker.id])
        BroadcastController.new.employer_update(c, "candidate_pool", job_ids)

        if !PurchasedProfile.where(:company_id => c, :job_seeker_id => job_seeker.id).empty?
          #BroadcastController.new.delay(:priority => 6).dashboard_update(c, job_seeker.id)

          #changes to dynamic updates
          BroadcastController.new.employer_update(c, "dashboard", [], [job_seeker.id])
        end
      end
    end
  end

  def self.pairing_value_job_job_seekers(job, from_where)
    feed_flag = false
    js_ids = Array.new
    if job.internal == true
      job_seeker_all = JobSeeker.find_by_sql("SELECT `job_seekers`.* FROM `job_seekers` join job_seeker_birkman_details on job_seekers.id = job_seeker_birkman_details.job_seeker_id WHERE (`job_seekers`.`deleted_at` IS NULL) AND (activated = 1 and ics_type_id IN (1,2,3) and company_id IN (#{job.company.path_ids.join(',')}) and grid_work_environment_x !='' and grid_work_environment_y !='' and grid_work_role_x !='' and grid_work_role_y !='')")
    else
      job_seeker_all = JobSeeker.find_by_sql("SELECT `job_seekers`.* FROM `job_seekers` join job_seeker_birkman_details on job_seekers.id = job_seeker_birkman_details.job_seeker_id WHERE (`job_seekers`.`deleted_at` IS NULL) AND (activated = 1 and (company_id IN (#{job.company.path_ids.join(',')}) OR company_id IS NULL) and grid_work_environment_x !='' and grid_work_environment_y !='' and grid_work_role_x !='' and grid_work_role_y !='')")
    end
    #pairing_value_arr = []
    for job_seeker in job_seeker_all
        if !job_seeker.job_seeker_desired_locations[0].nil?
          old_value = PairingLogic.find_by_sql("SELECT `pairing_logics`.* FROM `pairing_logics` where job_seeker_id = #{job_seeker.id} and job_id = #{job.id}").first
          old_value = old_value.pairing_value unless old_value.nil?
          pair_value = calculate_all_pairing_logic_parameter(job_seeker, job).round(5)
          #save pairing logic
          pairing = PairingLogic.where("job_seeker_id =? and job_id =?", job_seeker.id, job.id).first
          if pairing.nil?
            pairing = PairingLogic.new
          end
          pairing.job_seeker_id = job_seeker.id
          pairing.job_id = job.id
          pairing.pairing_value = pair_value
          pairing.save
          #pairing_value_arr << pairing
          #feed
          if from_where != "from_channel_manager" and from_where != "inactive_position_profile" and from_where != "from_rake_task"
            if pair_value != old_value
              js_ids<<job_seeker.id
              job_ids = Array.new
              job_ids<<job.id
              #BroadcastController.new.delay(:priority => 6).xref_update(job_seeker.id, job.company_id, job_ids)
              feed_flag = true
            end
          end
          employer_threshold(job, job_seeker, pair_value, from_where) if from_where != "inactive_position_profile" and from_where != "from_rake_task"
          if from_where != "inactive_position_profile" and from_where != "from_rake_task"
            #job_seeker alert threshold
            job_seeker_threshold(job, job_seeker, pair_value, from_where)
          end

          if from_where != "from_rake_task"
            following = JobSeekerFollowCompany.where("job_seeker_id = ? and company_id = ?",job_seeker.id,job.company.id).first

            if !following.nil?
              if from_where == "from_position_profile"
                @notification = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 17, :visibility => true, :company_id => job.company.id)
              else
                @notification = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 6, :visibility => true, :company_id => job.company.id)
              end
              job_seeker_alert = JobSeeker.where(:id=>job_seeker.id).first
              if job_seeker_alert.alert_method == ON_EVENT_EMAIL and !job_seeker_alert.request_deleted
                Notifier.email_job_seeker_notifications(job_seeker_alert, @notification).deliver
                job_seeker_alert.notification_email_time = DateTime.now
                job_seeker_alert.save(:validate => false)
              end
            end
          end
        end

    end
#    save_benchmark = Benchmark.measure {
#      PairingLogic.import pairing_value_arr, :on_duplicate_key_update => [:pairing_value]
#    }
#    puts "*******************************SAVE BENCHMARK**********************************"
#    puts save_benchmark
    #feed
    if feed_flag
      if job.internal == true
        job.company.path_ids.each do |c|
          BroadcastController.new.delay(:priority => 6).opportunities_internal(c, js_ids)
        end
      else
        job.company.path_ids.each do |c|
          BroadcastController.new.delay(:priority => 6).opportunities_internal(c, js_ids)
        end
        BroadcastController.new.delay(:priority => 6).opportunities_normal(js_ids)
      end
      #BroadcastController.new.delay(:priority => 6).candidate_update(job.id)

      #changes
      BroadcastController.new.employer_update(job.company_id, "dashboard", [job.id], js_ids)
      BroadcastController.new.employer_update(job.company_id, "candidate_pool", [job.id])
      BroadcastController.new.employer_update(job.company_id, "xref", [job.id], js_ids)
    end
    job.locked = false
    job.save(:validate => false)
  end

  def self.calculate_all_pairing_logic_parameter(job_seeker, job)
    #Multiplicative parameter.
    #language_requirements
    pyshometric_proximity, salary_fit, language_preferences, certification_preferences, geographic_preferences,
      roles, language_requirements, certification_requirements, desired_employment_requirements, education_level,
      university_affinity = 0.0

    language_requirements = language_requirements(job_seeker, job)
    if language_requirements != 0.0
      #certification_requirements
      certification_requirements = certification_requirements(job_seeker, job)
      
      if certification_requirements != 0.0
        #desired_employment_requirements
        desired_employment_requirements = desired_employment_requirements(job_seeker, job)

        if desired_employment_requirements != 0.0
          #Education Level
          education_level = education_level(job_seeker, job)

          if education_level != 0.0
            #University Affinity
            university_affinity = university_affinity(job_seeker, job)

            if university_affinity != 0.0
              #Additive Parameter.
              #pyshometric_proximity
              pyshometric_proximity = pyshometric_proximity(job_seeker, job)
              #salary_fit
              salary_fit = salary_fit(job_seeker, job)
              #language_preferences
              language_preferences = language_preferences(job_seeker, job)
              #certification_preferences
              certification_preferences = certification_preferences(job_seeker, job)
              #geographic_preferences
              geographic_preferences = geographic_preferences(job_seeker, job)
              #Roles
              roles = roles(job_seeker, job)

              pair_value = (pyshometric_proximity + salary_fit + language_preferences + certification_preferences + geographic_preferences + roles) * language_requirements * certification_requirements * desired_employment_requirements * education_level * university_affinity
            else
              pair_value = 0.0
            end
          else
            pair_value = 0.0
          end
        else
          pair_value = 0.0
        end
      else
        pair_value = 0.0
      end
    else
      pair_value = 0.0
    end
    
#    logger.info("****************pyshometric_proximity #{pyshometric_proximity}")
#    logger.info("****************salary_fit #{salary_fit}")
#    logger.info("****************language_preferences #{language_preferences}")
#    logger.info("****************certification_preferences #{certification_preferences}")
#    logger.info("****************geographic_preferences #{geographic_preferences}")
#    logger.info("****************roles #{roles}")
#    logger.info("****************language_requirements #{language_requirements}")
#    logger.info("****************certification_requirements #{certification_requirements}")
#    logger.info("****************desired_employment_requirements #{desired_employment_requirements}")
#    logger.info("****************education_level #{education_level}")
#    logger.info("****************university_affinity #{university_affinity}")
#    logger.info("****************PAIR VALUE #{pair_value}")
    return pair_value
  end

  def self.job_seeker_threshold(job, job_seeker, pair_value, from_where)
    alert_threshold = JobSeeker.where(:id=> job_seeker.id).first
    case alert_threshold.alert_threshold
    when 1
      if pair_value > 4
        if from_where == "from_position_profile"
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 14, :visibility => true, :company_id => job.company.id)
        else
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 10, :visibility => true, :company_id => job.company.id)
        end
        email_job_seeker(job_seeker.id, alert)
      elsif pair_value > 3 and pair_value <= 4
        if from_where == "from_position_profile"
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 15, :visibility => true, :company_id => job.company.id)
        else
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 11, :visibility => true, :company_id => job.company.id)
        end
        email_job_seeker(job_seeker.id, alert)
      elsif pair_value > 2 and pair_value <= 3
        if from_where == "from_position_profile"
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 16, :visibility => true, :company_id => job.company.id)
        else
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 12, :visibility => true, :company_id => job.company.id)
        end
        email_job_seeker(job_seeker.id, alert)
      end
    when 2
      if pair_value > 4
        if from_where == "from_position_profile"
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 14, :visibility => true, :company_id => job.company.id)
        else
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 10, :visibility => true, :company_id => job.company.id)
        end
        email_job_seeker(job_seeker.id, alert)
      elsif pair_value > 3 and pair_value <= 4
        if from_where == "from_position_profile"
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 15, :visibility => true, :company_id => job.company.id)
        else
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 11, :visibility => true, :company_id => job.company.id)
        end
        email_job_seeker(job_seeker.id, alert)
      end
    when 3
      if pair_value > 4
        if from_where == "from_position_profile"
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 14, :visibility => true, :company_id => job.company.id)
        else
          alert = JobSeekerNotification.create(:job_seeker_id => job_seeker.id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 10, :visibility => true, :company_id => job.company.id)
        end
        email_job_seeker(job_seeker.id, alert)
      end
    end
  end

  def self.employer_threshold(job, job_seeker, pair_value, from_where = nil)
    #employer alert threshold
    alert_threshold = Employer.find(job.employer_id).alert_threshold
    case alert_threshold
    when 3
      if pair_value > 4
        employer = job.employer
        employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => employer.id, :job_id => job.id, :purpose => "best-fit", :read => false)
        if employer.alert_method == ON_EVENT_EMAIL and !employer.request_deleted
          email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
          Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
          employer.notification_email_time = DateTime.now
          employer.save(:validate => false)
        end
      end
      check_for_parent_alerts(job, job_seeker, pair_value)
    when 2
      if pair_value > 4
        employer = job.employer
        employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => employer.id, :job_id => job.id, :purpose => "best-fit", :read => false)
        if employer.alert_method == ON_EVENT_EMAIL and !employer.request_deleted
          email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
          Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
          employer.notification_email_time = DateTime.now
          employer.save(:validate => false)
        end
      elsif pair_value > 3 and pair_value <= 4
        employer = job.employer
        employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => employer.id, :job_id => job.id, :purpose => "better-fit", :read => false)
        if employer.alert_method == ON_EVENT_EMAIL and !employer.request_deleted
          email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
          Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
          employer.notification_email_time = DateTime.now
          employer.save(:validate => false)
        end
      end
      check_for_parent_alerts(job, job_seeker, pair_value)
    when 1
      if pair_value > 4
        employer = job.employer
        employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => employer.id, :job_id => job.id, :purpose => "best-fit", :read => false)
        if employer.alert_method == ON_EVENT_EMAIL and !employer.request_deleted
          email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
          Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
          employer.notification_email_time = DateTime.now
          employer.save(:validate => false)
        end
      elsif pair_value > 3 and pair_value <= 4
        employer = job.employer
        employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => employer.id, :job_id => job.id, :purpose => "better-fit", :read => false)
        if employer.alert_method == ON_EVENT_EMAIL and !employer.request_deleted
          email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
          Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
          employer.notification_email_time = DateTime.now
          employer.save(:validate => false)
        end
      elsif pair_value > 2 and pair_value <= 3
        employer = job.employer
        employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => employer.id, :job_id => job.id, :purpose => "good-fit", :read => false)
        if job.employer.alert_method == ON_EVENT_EMAIL and !employer.request_deleted
          email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
          Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
          employer.notification_email_time = DateTime.now
          employer.save(:validate => false)
        end
      end
      check_for_parent_alerts(job, job_seeker, pair_value)
    end
  end

  def self.check_for_parent_alerts(job, job_seeker, pair_value)
    all_parent_employers = job.employer.ancestors
    all_parent_employers.each do |parent_employer|
      alert_threshold = parent_employer.alert_threshold
      case alert_threshold
      when 3
        if pair_value > 4
          employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => parent_employer.id, :job_id => job.id, :purpose => "best-fit", :read => false)
          if parent_employer.alert_method == ON_EVENT_EMAIL and !parent_employer.request_deleted
            email_hash = {:employer_first_name => parent_employer.first_name, :employer_email => parent_employer.email, :employer_alerts => employer_alerts.id}
            Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
            parent_employer.notification_email_time = DateTime.now
            parent_employer.save(:validate => false)
          end
        end
      when 2
        if pair_value > 4
          employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => parent_employer.id, :job_id => job.id, :purpose => "best-fit", :read => false)
          if parent_employer.alert_method == ON_EVENT_EMAIL and !parent_employer.request_deleted
            email_hash = {:employer_first_name => parent_employer.first_name, :employer_email => parent_employer.email, :employer_alerts => employer_alerts.id}
            Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
            parent_employer.notification_email_time = DateTime.now
            parent_employer.save(:validate => false)
          end
        elsif pair_value > 3 and pair_value <= 4
          employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => parent_employer.id, :job_id => job.id, :purpose => "better-fit", :read => false)
          if parent_employer.alert_method == ON_EVENT_EMAIL and !parent_employer.request_deleted
            email_hash = {:employer_first_name => parent_employer.first_name, :employer_email => parent_employer.email, :employer_alerts => employer_alerts.id}
            Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
            parent_employer.notification_email_time = DateTime.now
            parent_employer.save(:validate => false)
          end
        end
      when 1
        if pair_value > 4
          employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => parent_employer.id, :job_id => job.id, :purpose => "best-fit", :read => false)
          if parent_employer.alert_method == ON_EVENT_EMAIL and !parent_employer.request_deleted
            email_hash = {:employer_first_name => parent_employer.first_name, :employer_email => parent_employer.email, :employer_alerts => employer_alerts.id}
            Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
            parent_employer.notification_email_time = DateTime.now
            parent_employer.save(:validate => false)
          end
        elsif pair_value > 3 and pair_value <= 4
          employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => parent_employer.id, :job_id => job.id, :purpose => "better-fit", :read => false)
          if parent_employer.alert_method == ON_EVENT_EMAIL and !parent_employer.request_deleted
            email_hash = {:employer_first_name => parent_employer.first_name, :employer_email => parent_employer.email, :employer_alerts => employer_alerts.id}
            Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
            parent_employer.notification_email_time = DateTime.now
            parent_employer.save(:validate => false)
          end
        elsif pair_value > 2 and pair_value <= 3
          employer_alerts = EmployerAlert.create(:job_seeker_id => job_seeker.id, :employer_id => parent_employer.id, :job_id => job.id, :purpose => "good-fit", :read => false)
          if parent_employer.alert_method == ON_EVENT_EMAIL and !parent_employer.request_deleted
            email_hash = {:employer_first_name => parent_employer.first_name, :employer_email => parent_employer.email, :employer_alerts => employer_alerts.id}
            Notifier.delay(:priority => 6).email_employer_notifications(email_hash)
            parent_employer.notification_email_time = DateTime.now
            parent_employer.save(:validate => false)
          end
        end
      end
    end
  end

  def self.email_job_seeker(job_seeker_id, alert)
    job_seeker = JobSeeker.where(:id => job_seeker_id).first
    if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
      Notifier.email_job_seeker_notifications(job_seeker, alert).deliver
      job_seeker.notification_email_time = DateTime.now
      job_seeker.save(:validate => false)
    end
  end

  def self.pyshometric_proximity(job_seeker, job)
    grid_work = JobSeekerBirkmanDetail.find_by_sql("SELECT `job_seeker_birkman_details`.* FROM `job_seeker_birkman_details` WHERE (job_seeker_id = #{job_seeker.id}) LIMIT 1").first
    x2_work = grid_work.grid_work_environment_x.to_i
    y2_work = grid_work.grid_work_environment_y.to_i
    x2_role = grid_work.grid_work_role_x.to_i
    y2_role = grid_work.grid_work_role_y.to_i

    delta_x_work = x2_work - job.grid_work_environment_x.to_i
    delta_y_work = y2_work - job.grid_work_environment_y.to_i

    delta_x_role = x2_role - job.grid_work_role_x.to_i
    delta_y_role = y2_role - job.grid_work_role_y.to_i

    delta_work = Math.sqrt((delta_x_work**2) + (delta_y_work**2))
    delta_role = Math.sqrt((delta_x_role**2) + (delta_y_role**2))

    pyshometric_proximity = PSYCHOMETRIC_CONSTANT * ((142 - delta_role)/142 + (142 - delta_work)/142)
    return pyshometric_proximity
  end

  def self.salary_fit(job_seeker, job)
    if job_seeker.minimum_compensation_amount == 0
      salary_fit = 0.0
    else
      salary_fit = SALARY_FIT_CONSTATNT * Math.log10(job.minimum_compensation_amount / job_seeker.minimum_compensation_amount)
    end
    return salary_fit
  end

  def self.language_preferences(job_seeker, job)
    flag_language_number_matched = 0.0
    job_desired_language = JobCriteriaLanguage.find_by_sql("SELECT `job_criteria_languages`.* FROM `job_criteria_languages` WHERE `job_criteria_languages`.`job_id` = #{job.id} AND (job_criteria_languages.required_flag = 0)")
    for i in 0 .. job_seeker.job_seeker_languages.size-1
      for j in 0 .. job_desired_language.size-1
        if job_seeker.job_seeker_languages[i].language_id == job_desired_language[j].language_id
          flag_language_number_matched = flag_language_number_matched + 1
        end
      end
    end
    if job_desired_language.size == 0
      language_preferences = 0.0
    else
      language_preferences = LANGUAGE_CONSTANT * (flag_language_number_matched / job_desired_language.size)
    end
    return language_preferences
  end

  def self.certification_preferences(job_seeker, job)
    flag_certificate_number_matched = 0.0
    job_desired_certificate = JobCriteriaCertificate.find_by_sql("SELECT `job_criteria_certificates`.* FROM `job_criteria_certificates` WHERE `job_criteria_certificates`.`job_id` = #{job.id} AND (job_criteria_certificates.required_flag =0)")
    for i in 0 .. job_seeker.job_seeker_certificates.size-1
      for j in 0 .. job_desired_certificate.size-1
        if not job_seeker.job_seeker_certificates.nil? and not job_desired_certificate.nil?
          if job_seeker.job_seeker_certificates[i].new_certificate_id.nil?
#            logger.info("*********job_seeker.job_seeker_certificates[i].license_id #{job_seeker.job_seeker_certificates[i].license_id}")
#            logger.info("*********job_desired_certificate[j].license_id #{job_desired_certificate[j].license_id}")
            if job_seeker.job_seeker_certificates[i].license_id == job_desired_certificate[j].license_id
              flag_certificate_number_matched = flag_certificate_number_matched + 1
            end
          else
#            logger.info("*********job_seeker.job_seeker_certificates[i].new_certificate_id #{job_seeker.job_seeker_certificates[i].new_certificate_id}")
#            logger.info("*********job_desired_certificate[j].new_certificate_id #{job_desired_certificate[j].new_certificate_id}")
            if job_seeker.job_seeker_certificates[i].new_certificate_id == job_desired_certificate[j].new_certificate_id
              flag_certificate_number_matched = flag_certificate_number_matched + 1
            end
          end
        end
      end
    end
    if job_desired_certificate.size == 0
      certification_preferences = 0.0
    else
#      logger.info("**************flag_certificate_number_matched#{flag_certificate_number_matched}")
#      logger.info("**************job_desired_certificate.size#{job_desired_certificate.size}")
      certification_preferences = CERTIFICATION_CONSTANT * (flag_certificate_number_matched / job_desired_certificate.size)
    end
    return certification_preferences
  end

  def self.language_requirements(job_seeker, job)
    flag_language = 0
    job_required_language = JobCriteriaLanguage.find_by_sql("SELECT `job_criteria_languages`.* FROM `job_criteria_languages` WHERE `job_criteria_languages`.`job_id` = #{job.id} AND (job_criteria_languages.required_flag =1)")
    for i in 0 .. job_seeker.job_seeker_languages.size-1
      for j in 0 .. job_required_language.size-1
        if job_seeker.job_seeker_languages[i].language_id == job_required_language[j].language_id
          flag_language = flag_language + 1
        end
      end
    end
    if flag_language == job_required_language.size
      language_requirements = 1
    else
      language_requirements = 0
    end
    return language_requirements
  end

  def self.certification_requirements(job_seeker, job)
    flag_certificate = 0
    job_required_certificate = JobCriteriaCertificate.find_by_sql("SELECT `job_criteria_certificates`.* FROM `job_criteria_certificates` WHERE `job_criteria_certificates`.`job_id` = #{job.id} AND (job_criteria_certificates.required_flag =1)")
    for i in 0 .. job_seeker.job_seeker_certificates.size-1
      for j in 0 .. job_required_certificate.size-1
        if job_seeker.job_seeker_certificates[i].new_certificate_id.nil?
          if job_seeker.job_seeker_certificates[i].license_id == job_required_certificate[j].license_id
            flag_certificate = flag_certificate + 1
          end
        else
          if job_seeker.job_seeker_certificates[i].new_certificate_id == job_required_certificate[j].new_certificate_id
            flag_certificate = flag_certificate + 1
          end
        end
      end
    end

    if flag_certificate == job_required_certificate.size
      certification_requirements = 1
    else
      certification_requirements = 0
    end
    return certification_requirements
  end

  def self.geographic_preferences(job_seeker, job)
    if job_seeker.job_seeker_desired_locations[0].desired_location_id == 2
      geographic_preferences = 0
    else
      if job.remote_work == true
        geographic_preferences = 0
      else
        px = 50
        if job_seeker.job_seeker_desired_locations[0].latitude.nil? or job_seeker.job_seeker_desired_locations[0].longitude.nil? or job.job_location.latitude.nil? or job.job_location.longitude.nil?
          d = 20037.58
        else
          d = haversine_distance(job_seeker.job_seeker_desired_locations[0].latitude,job_seeker.job_seeker_desired_locations[0].longitude, job.job_location.latitude,job.job_location.longitude)
        end
        geographic_preferences = GEOGRAPHICAL_CONSTANT * (((d-px)/px)/(1 + ((d-px)/px).abs))
      end
    end
    return geographic_preferences
  end

  def self.desired_employment_requirements(job_seeker, job)
    flag_employment = 0
    for i in 0 .. job_seeker.job_seeker_desired_employments.size-1
      for j in 0 .. job.job_criteria_desired_employments.size-1
        if job_seeker.job_seeker_desired_employments[i].desired_employment_id == job.job_criteria_desired_employments[j].desired_employment_id
          flag_employment = 1
          break
        end
      end
      if flag_employment == 1
        break
      end
    end

    if flag_employment == 1
      desired_employment_requirements = 1
    else
      desired_employment_requirements = 0
    end
    return desired_employment_requirements
  end

  def self.roles(job_seeker, job)
    score = 0.0
    job_seeker_roles = AddedRole.find_by_sql("SELECT `added_roles`.* FROM `added_roles` WHERE (adder_type = 'JobSeeker' and adder_id = #{job_seeker.id})")
    job_roles = AddedRole.find_by_sql("SELECT `added_roles`.* FROM `added_roles` WHERE (adder_type = 'JobPosition' and adder_id = #{job.id})")
    for i in 0 .. job_seeker_roles.size-1
      for j in 0 .. job_roles.size-1
        if job_seeker_roles[i].code == job_roles[j].code
          score = score + job_seeker_roles[i].education_level.score + job_seeker_roles[i].experience_level.score
        end
      end
    end

    if job_roles.size == 0
      roles = 0
    else
      roles = ROLES_CONSTANT * (score/job_roles.size)
    end
    return roles
  end

  def self.education_level(job_seeker, job)
    job_seeker_degree = AddedDegree.find_by_sql("SELECT `added_degrees`.* FROM `added_degrees` WHERE (adder_type = 'JobSeeker' and adder_id = #{job_seeker.id}) LIMIT 1").first
    job_degree = AddedDegree.find_by_sql("SELECT `added_degrees`.* FROM `added_degrees` WHERE (adder_type = 'JobPosition' and adder_id = #{job.id}) LIMIT 1").first
    if not job_seeker_degree.nil?
      job_seeker_degree_value = job_seeker_degree.degree.value
    else
      job_seeker_degree_value = 0
    end

    if not job_degree.nil?
      job_degree_value = job_degree.degree.value
    else
      job_degree_value = 0
    end

    if job_degree_value == 0
      education_level = 1
    elsif job_degree.required_flag == false
      if job_degree_value <= job_seeker_degree_value
        education_level = 1
      else
        education_level = 0.85
      end
    elsif job_degree.required_flag == true
      if job_degree_value <= job_seeker_degree_value
        education_level = 1
      else
        education_level = 0
      end
    end
    return education_level
  end

  def self.university_affinity(job_seeker, job)
    flag_university = 0
    job_seeker_univ = AddedUniversity.find_by_sql("SELECT `added_universities`.* FROM `added_universities` join universities on added_universities.university_id = universities.id WHERE (adder_type = 'JobSeeker' and adder_id = #{job_seeker.id} and universities.activated = 1)")
    job_univ = AddedUniversity.find_by_sql("SELECT `added_universities`.* FROM `added_universities` join universities on added_universities.university_id = universities.id WHERE (adder_type = 'JobPosition' and adder_id = #{job.id} and universities.activated = 1)")
    for i in 0 .. job_seeker_univ.size-1
      for j in 0 .. job_univ.size-1
        if job_seeker_univ[i].university_id == job_univ[j].university_id
          flag_university = 1
          break
        end
      end
      if flag_university == 1
        break
      end
    end

    if flag_university == 1
      university_affinity = 1.1
    else
      university_affinity = 1.0
    end
    return university_affinity
  end

  def self.haversine_distance( lat1, lon1, lat2, lon2 )
    dlon = lon2 - lon1
    dlat = lat2 - lat1

    dlon_rad = dlon * RAD_PER_DEG
    dlat_rad = dlat * RAD_PER_DEG

    lat1_rad = lat1 * RAD_PER_DEG

    lat2_rad = lat2 * RAD_PER_DEG

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.asin( Math.sqrt(a))

    dKm = Rkm * c             # delta in kilometers
    return dKm
  end
end
