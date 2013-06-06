# coding: UTF-8

require 'test_helper'

class JobProfileResponsibilityTest < ActiveSupport::TestCase
  should belong_to :job
  should belong_to :profile_responsibility
end