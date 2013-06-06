# coding: UTF-8

class JobCriteriaLanguage < ActiveRecord::Base
  attr_accessible :language_id, :proficiency_val, :required_flag, :job_id
  belongs_to :job
  belongs_to :language
  audited
end
