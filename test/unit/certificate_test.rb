# coding: UTF-8

require 'test_helper'

class CertificateTest < ActiveSupport::TestCase
  should have_many(:job_seeker_certificates).dependent(:destroy)
  should have_many(:job_seekers).through(:job_seeker_certificates)
  should have_many(:job_criteria_certificates).dependent(:destroy)
  should have_many(:jobs).through(:job_criteria_certificates)

  should allow_value("Oracle Sun Certified Java Programmer").for(:name)
end