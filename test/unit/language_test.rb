# coding: UTF-8

require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  @language = FactoryGirl.build(:language)
  language  = @language.name

  should "test language" do
    assert_equal "English", language
  end

  should have_many(:job_seeker_languages).dependent(:destroy)
  should have_many(:job_seekers).through(:job_seeker_languages)

  should have_many(:job_criteria_languages).dependent(:destroy)
  should have_many(:jobs).through(:job_criteria_languages)

  should allow_value("English").for(:name)
end