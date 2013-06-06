# coding: UTF-8

class JobSeekerDesiredEmployment < ActiveRecord::Base
  attr_accessible :desired_employment_id
  belongs_to :job_seeker
  belongs_to :desired_employment
end
