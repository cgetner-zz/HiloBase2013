# coding: UTF-8

require 'test_helper'

class BirkmanJobInterestTest < ActiveSupport::TestCase
  should allow_value(100001).for(:set_number)
end