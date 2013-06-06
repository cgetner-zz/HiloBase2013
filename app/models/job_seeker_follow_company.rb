# coding: UTF-8

class JobSeekerFollowCompany < ActiveRecord::Base
  attr_accessible :company_id, :job_seeker_id
  belongs_to :job_seeker
  belongs_to :company
end
