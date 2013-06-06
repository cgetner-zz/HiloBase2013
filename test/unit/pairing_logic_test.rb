# coding: UTF-8

require 'test_helper'

class PairingLogicTest < ActiveSupport::TestCase
  should belong_to :job
  should belong_to :job_seeker
end