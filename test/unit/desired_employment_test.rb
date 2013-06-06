# coding: UTF-8

require 'test_helper'

class DesiredEmploymentTest < ActiveSupport::TestCase
  should have_many(:job_seeker_desired_employments).dependent(:destroy)
  should have_many(:job_seekers).through(:job_seeker_desired_employments)
  should have_many(:job_criteria_desired_employments).dependent(:destroy)
  should have_many(:jobs).through(:job_criteria_desired_employments)

  should allow_value("Desired Employment").for(:name)
end