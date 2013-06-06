# coding: UTF-8

class JobSeekerProficiency < ActiveRecord::Base
  attr_accessible :job_seeker_id, :proficiency_id, :education_id, :skill_id
  belongs_to :job_seeker
  belongs_to :proficiency
end
