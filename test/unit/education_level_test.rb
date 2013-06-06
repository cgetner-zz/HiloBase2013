# coding: UTF-8

require 'test_helper'

class EducationLevelTest < ActiveSupport::TestCase
  should allow_value("Graduate").for(:name)
end