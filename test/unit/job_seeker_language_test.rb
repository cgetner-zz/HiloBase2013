# coding: UTF-8

require 'test_helper'

class JobSeekerLanguageTest < ActiveSupport::TestCase
  should belong_to :job_seeker
  should belong_to :language
  
  should allow_value(1).for(:language_id)
end