# coding: UTF-8

require 'test_helper'

class JobSeekerFollowCompanyTest < ActiveSupport::TestCase
  should allow_value(1).for(:company_id)
  should allow_value(1).for(:job_seeker_id)
end