# coding: UTF-8

require 'test_helper'

class JobRoleQuestionTest < ActiveSupport::TestCase
  should belong_to :job

  should allow_value(1).for(:role_question_id)
  should allow_value(1).for(:job_id)
end