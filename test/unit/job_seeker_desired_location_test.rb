# coding: UTF-8

require 'test_helper'

class JobSeekerDesiredLocationTest < ActiveSupport::TestCase
  should belong_to :job_seeker

  should allow_value(1).for(:desired_location_id)
  should allow_value("Philadelphia").for(:city)
end