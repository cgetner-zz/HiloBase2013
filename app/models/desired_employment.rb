# coding: UTF-8

class DesiredEmployment < ActiveRecord::Base
  attr_accessible :name
  has_many :job_seeker_desired_employments,:dependent=>:destroy
  has_many :job_seekers,:through=>:job_seeker_desired_employments
  
  
  has_many :job_criteria_desired_employments,:dependent=>:destroy
  has_many :jobs,:through=>:job_criteria_desired_employments
end
