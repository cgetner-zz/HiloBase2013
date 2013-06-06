# coding: UTF-8

require 'test_helper'

class OwnerShipTypeTest < ActiveSupport::TestCase
  should have_many :companies

  should allow_value("Privately Owned").for(:name)
end