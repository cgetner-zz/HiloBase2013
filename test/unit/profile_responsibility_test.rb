# coding: UTF-8

require 'test_helper'

class ProfileResponsibilityTest < ActiveSupport::TestCase
  should have_many(:job_profile_responsibilities).dependent(:destroy)
  should have_many(:jobs).through(:job_profile_responsibilities)
end