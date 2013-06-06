# coding: UTF-8

require 'test_helper'

class ProficiencyTest < ActiveSupport::TestCase
  should have_many(:job_seeker_proficiencies).dependent(:destroy)
  should have_many(:job_seekers).through(:job_seeker_proficiencies)

  should have_many(:job_criteria_proficiencies).dependent(:destroy)
  should have_many(:jobs).through(:job_criteria_proficiencies)

  should allow_value(0).for(:activated)
end