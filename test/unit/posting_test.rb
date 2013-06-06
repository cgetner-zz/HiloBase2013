# coding: UTF-8

require 'test_helper'

class PostingTest < ActiveSupport::TestCase
  should allow_value(0).for(:hilo_share)
  should allow_value(165).for(:hilo_count)
end