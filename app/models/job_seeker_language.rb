# coding: UTF-8

class JobSeekerLanguage < ActiveRecord::Base
  attr_accessible :language_id, :proficiency_val
  belongs_to :job_seeker
  belongs_to :language
end
