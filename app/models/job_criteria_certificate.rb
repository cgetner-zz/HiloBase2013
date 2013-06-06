# coding: UTF-8

class JobCriteriaCertificate < ActiveRecord::Base
  attr_accessible :job_id, :certificate_id, :new_certificate_id, :license_id, :order
  belongs_to :job
  #belongs_to :certificate
  belongs_to :new_certificate
  belongs_to :license
  audited
end
