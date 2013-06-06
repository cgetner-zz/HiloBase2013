# coding: UTF-8

require 'test_helper'

class DesiredLocationTest < ActiveSupport::TestCase
  should allow_value("New York").for(:name)
end