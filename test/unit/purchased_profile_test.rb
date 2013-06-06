# coding: UTF-8

require 'test_helper'

class PurchasedProfileTest < ActiveSupport::TestCase
  should allow_value(1).for(:job_seeker_id)
  should allow_value(6).for(:employer_id)
  should allow_value(5).for(:payment_id)
  should allow_value(71).for(:job_id)
end