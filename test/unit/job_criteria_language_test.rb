# coding: UTF-8

require 'test_helper'

class JobCriteriaLanguageTest < ActiveSupport::TestCase
  should belong_to :job
  should belong_to :language

  should allow_value(1).for(:language_id)
end