# coding: UTF-8

require 'test_helper'

class JobCriteriaCertificateTest < ActiveSupport::TestCase
  should belong_to :job
  should belong_to :certificate

  should allow_value(1).for(:job_id)
  should allow_value(1).for(:certificate_id)
end