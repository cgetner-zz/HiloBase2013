# coding: UTF-8

class EducationLevel < ActiveRecord::Base
  attr_accessible :name, :score

   has_many :added_roles
#  has_many :job_seeker_education_levels, :dependent => :destroy
#  has_many :job_seekers, :through => :job_seeker_education_levels
end
