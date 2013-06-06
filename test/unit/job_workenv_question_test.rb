# coding: UTF-8

require 'test_helper'

class JobWorkenvQuestionTest < ActiveSupport::TestCase
  should belong_to :job

  should allow_value(1).for(:job_id)
  should allow_value(1).for(:workenv_question_id)
end