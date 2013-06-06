# coding: UTF-8

require 'test_helper'

class JobLocationTest < ActiveSupport::TestCase
  should have_many :jobs

  should allow_value("U.S.A.").for(:country)
  should allow_value("New York").for(:city)
  should allow_value(23434).for(:zip_code)
  should allow_value("").for(:country)
  should allow_value("").for(:city)
end