# coding: UTF-8

class SkillLevel < ActiveRecord::Base
  attr_accessible :name
#  has_many :job_seeker_skill_levels, :dependent => :destroy
#  has_many :skill_levels, :through => :job_seeker_skill_levels
end
