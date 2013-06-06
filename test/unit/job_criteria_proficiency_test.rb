# coding: UTF-8

require 'test_helper'

class JobCriteriaProficiencyTest < ActiveSupport::TestCase
  should belong_to :job
  should belong_to :proficiency

  should allow_value(1).for(:proficiency_id)
end