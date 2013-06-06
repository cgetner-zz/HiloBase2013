# coding: UTF-8

class JobCriteriaDesiredEmployment < ActiveRecord::Base
  attr_accessible :desired_employment_id, :job_id
  belongs_to :job
  belongs_to :desired_employment
end
