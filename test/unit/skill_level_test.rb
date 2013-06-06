# coding: UTF-8

require 'test_helper'

class SkillLevelTest < ActiveSupport::TestCase
  @skill_level = FactoryGirl.build(:skill_level)
  skill_level  = @skill_level.name

  should "test skill level" do
    assert_equal "Graduate", skill_level
  end
  should allow_value("Course Level").for(:name)
end