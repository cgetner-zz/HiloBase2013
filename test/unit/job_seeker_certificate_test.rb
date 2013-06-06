# coding: UTF-8

require 'test_helper'

class JobSeekerCertificateTest < ActiveSupport::TestCase
  should belong_to :job_seeker
  should belong_to :certificate
end