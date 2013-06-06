# coding: UTF-8

class JobSeekerCertificate < ActiveRecord::Base
  attr_accessible :job_seeker_id, :new_certificate_id, :license_id, :order
  belongs_to :job_seeker
  #belongs_to :certificate
  belongs_to :new_certificate
  belongs_to :license
  audited
end
