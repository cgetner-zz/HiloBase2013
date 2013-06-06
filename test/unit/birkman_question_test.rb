# coding: UTF-8

require 'test_helper'

class BirkmanQuestionTest < ActiveSupport::TestCase
  should allow_value(100001).for(:set_number)
end