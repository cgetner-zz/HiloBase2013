class NewCertificate < ActiveRecord::Base
  attr_accessible :occupation, :sub_occupation, :certification_name, :certifying_organization, :certification_description, :source_url, :activated
  self.primary_key = 'id'
  has_many :job_seeker_certificates, :dependent => :destroy
  has_many :job_seekers, :through => :job_seeker_certificates    
  has_many :job_criteria_certificates, :dependent => :destroy
  has_many :jobs, :through => :job_criteria_certificates
end
