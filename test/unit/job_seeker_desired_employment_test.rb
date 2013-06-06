# coding: UTF-8

require 'test_helper'

class JobSeekerDesiredEmploymentTest < ActiveSupport::TestCase
  should belong_to :job_seeker
  should belong_to :desired_employment

  should allow_value(1).for(:desired_employment_id)
end