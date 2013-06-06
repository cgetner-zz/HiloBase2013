# coding: UTF-8

require 'test_helper'

class BirkmanQuestionResponseTest < ActiveSupport::TestCase
  should allow_value(1).for(:birkman_question_id)
  should allow_value(1).for(:job_seeker_id)
end