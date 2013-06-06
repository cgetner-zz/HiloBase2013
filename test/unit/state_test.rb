# coding: UTF-8

require 'test_helper'

class StateTest < ActiveSupport::TestCase
  should allow_value("Washington").for(:name)
end