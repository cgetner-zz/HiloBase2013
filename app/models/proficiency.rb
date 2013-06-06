# coding: UTF-8

class Proficiency < ActiveRecord::Base
  attr_accessible :name, :created_by, :activated
    has_many :job_seeker_proficiencies,:dependent=>:destroy
    has_many :job_seekers,:through=>:job_seeker_proficiencies
    
    
    has_many :job_criteria_proficiencies,:dependent=>:destroy
    has_many :jobs,:through=>:job_criteria_proficiencies
end
