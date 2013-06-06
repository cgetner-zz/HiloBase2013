# coding: UTF-8

class JobCriteriaProficiency < ActiveRecord::Base
  attr_accessible :proficiency_id
  belongs_to :job
  belongs_to :proficiency
end
