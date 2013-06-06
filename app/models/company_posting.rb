# coding: UTF-8
class CompanyPosting < ActiveRecord::Base
  attr_accessible :company_id
  belongs_to :company
  
  def self.log_entry(company_id, platform_id)
    log_entry = CompanyPosting.find_by_company_id(company_id)
    if log_entry.nil?
      log_entry = CompanyPosting.new
      log_entry.company_id = company_id
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
