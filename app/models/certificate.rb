# coding: UTF-8

class Certificate < ActiveRecord::Base
  attr_accessible :name, :created_by, :user_type, :activated
  
  has_many :job_seeker_certificates, :dependent => :destroy
  has_many :job_seekers, :through => :job_seeker_certificates    
  has_many :job_criteria_certificates, :dependent => :destroy
  has_many :jobs, :through => :job_criteria_certificates
end
