# coding: UTF-8

require 'test_helper'

class JobSeekerWatchlistTest < ActiveSupport::TestCase
  should allow_value(1).for(:job_id)
  should allow_value(1).for(:job_seeker_id)
end