# coding: UTF-8

class LogShare < ActiveRecord::Base
  attr_accessible :job_id, :share_platform_id, :job_seeker_id
  belongs_to :job
  def self.log_job(job_id,platform_id,seeker_id)
      create({:job_id => job_id,:share_platform_id => platform_id,:job_seeker_id => seeker_id})
  end
end
