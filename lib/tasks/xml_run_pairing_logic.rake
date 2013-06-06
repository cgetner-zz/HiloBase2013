namespace :xml_run_pairing_logic do
  desc "Run pairing logic for wrapped jobs"
  task(:data => :environment) do

    def run_pairing_logic
      jobs_list = Job.where(:xml_import_pairing_logic => true).where(:locked => false).limit(50)
      # lock jobs for this cron
      jobs_list.each do |job|
        job.xml_import_pairing_logic = false
        job.locked = true
        job.save(:validate => false)
      end
      # process those locked jobs
      job_active_array = []
      jobs_list.each do |job|
        start_time = Time.now
        puts "Processing for a job #{job.id} started at: #{start_time}"
        if job.active == false
          job.expire_at = Time.now + (60 * 24 * 60 * 60)
        end
        posting_record = Posting.where("job_id = ? and employer_id = ?", job.id, job.employer.id).first
        if posting_record.nil?
          posting_record = Posting.new
          posting_record.job_id = job.id
          posting_record.hilo_share = true
          posting_record.facebook_share = false
          posting_record.linkedin_share = false
          posting_record.twitter_share = false
          posting_record.url_share = false
          posting_record.employer_id = job.employer.id
          posting_record.save!
        end
        job.active = true
        job_active_array << job
#        job.save(:validate => false)
        PairingLogic.pairing_value_job(job, "from_rake_task")
        end_time = Time.now - start_time
        puts "Time taken for pairing logic is : #{end_time}"
      end
      Job.import job_active_array, :on_duplicate_key_update => [:expire_at, :active]
    end
    run_pairing_logic()
  end
end