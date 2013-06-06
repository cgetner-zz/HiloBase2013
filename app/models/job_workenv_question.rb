# coding: UTF-8

class JobWorkenvQuestion < ActiveRecord::Base
  attr_accessible :workenv_question_id, :score, :job_id
  belongs_to :job
  audited
end
