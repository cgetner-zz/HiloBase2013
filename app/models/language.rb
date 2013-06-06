# coding: UTF-8

class Language < ActiveRecord::Base
  attr_accessible :name
    has_many :job_seeker_languages,:dependent=>:destroy
    has_many :job_seekers,:through=>:job_seeker_languages
    
    has_many :job_criteria_languages,:dependent=>:destroy
    has_many :jobs,:through=>:job_criteria_languages
end
