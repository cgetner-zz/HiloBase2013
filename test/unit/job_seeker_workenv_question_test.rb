# coding: UTF-8

require 'test_helper'

class JobSeekerWorkenvQuestionTest < ActiveSupport::TestCase
  should allow_value(1).for(:workenv_question_id)
  should allow_value(1).for(:job_seeker_id)
end