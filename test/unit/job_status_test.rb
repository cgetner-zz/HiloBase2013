# coding: UTF-8

require 'test_helper'

class JobStatusTest < ActiveSupport::TestCase
  should allow_value(1).for(:job_id)
  should allow_value(5).for(:job_seeker_id)

  should "test methods in model" do
    ##RSPEC: Method Name cost_for_purpose(purpose)
    assert_equal 3.99, JobStatus.cost_for_purpose("interest")
  end
end