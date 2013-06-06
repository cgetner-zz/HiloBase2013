# coding: UTF-8

require 'test_helper'

class JobSeekerProficiencyTest < ActiveSupport::TestCase
  should belong_to :job_seeker
  should belong_to :proficiency

  should allow_value(1).for(:job_seeker_id)
  should allow_value(1).for(:proficiency_id)
  should allow_value(1).for(:education_id)
  should allow_value(1).for(:skill_id)
end