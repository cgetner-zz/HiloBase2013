# coding: UTF-8

class JobRoleQuestion < ActiveRecord::Base
  attr_accessible :role_question_id, :score, :job_id
  belongs_to :job
end
