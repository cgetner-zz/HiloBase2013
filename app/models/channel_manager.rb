# coding: UTF-8

class ChannelManager < ActiveRecord::Base
  belongs_to :job

  def self.log_entry(job_id, platform_id)
    log_entry = ChannelManager.find_by_job_id(job_id)
    if log_entry.nil?
      log_entry = ChannelManager.new
      log_entry.job_id = job_id
    end
    case platform_id.to_i
      when 1
        if log_entry.twitter_count.nil?
          log_entry.twitter_count = 0
        end
        log_entry.twitter_count = log_entry.twitter_count + 1
      when  2
        if log_entry.facebook_count.nil?
          log_entry.facebook_count = 0
        end
        log_entry.facebook_count = log_entry.facebook_count + 1
      when 3
        if log_entry.linkedin_count.nil?
          log_entry.linkedin_count = 0
        end
        log_entry.linkedin_count = log_entry.linkedin_count + 1
      when 4
        if log_entry.url_count.nil?
          log_entry.url_count = 0
        end
        log_entry.url_count = log_entry.url_count + 1
      when 5
        if log_entry.hilo_count.nil?
          log_entry.hilo_count = 0
        end
        log_entry.hilo_count = log_entry.hilo_count + 1
    end
    log_entry.save
  end
end
