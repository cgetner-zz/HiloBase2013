# coding: UTF-8

require 'test_helper'

class BirkmanJobInterestResponseTest < ActiveSupport::TestCase
  should allow_value(1).for(:birkman_job_interest_id)
  should allow_value(2).for(:job_seeker_id)
  should allow_value("second").for(:choice)
end