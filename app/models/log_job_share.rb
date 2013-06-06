# coding: UTF-8

class LogJobShare < ActiveRecord::Base

  belongs_to :job
  belongs_to :share_platform
  belongs_to :job_seeker
  
  def self.log_job(job_id,platform_id,seeker_id)
    log_job = LogJobShare.find_by_job_seeker_id_and_job_id(seeker_id, job_id)
    if log_job.nil?
      log_job = LogJobShare.new
      log_job.job_id = job_id
      log_job.share_platform_id = platform_id
      log_job.job_seeker_id = seeker_id
      log_job.save
    end
      #create({:job_id => job_id,:share_platform_id => platform_id,:job_seeker_id => seeker_id})
  end
  
end

