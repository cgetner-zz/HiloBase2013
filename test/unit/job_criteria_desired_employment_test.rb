# coding: UTF-8

require 'test_helper'

class JobCriteriaDesiredEmploymentTest < ActiveSupport::TestCase
  should belong_to :job
  should belong_to :desired_employment

  should allow_value(1).for(:desired_employment_id)
end