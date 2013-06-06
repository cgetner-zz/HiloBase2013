# coding: UTF-8

require 'test_helper'

class RoleQuestionTest < ActiveSupport::TestCase
  should allow_value(49).for(:xscoring)
  should allow_value(50).for(:yscoring)

  should "test methods in model" do
    ##RSPEC: Method Name section_by_score(x_score,y_score)
    assert_equal "bottom_left", RoleQuestion.section_by_score(25,25)
    assert_not_equal "top_left", RoleQuestion.section_by_score(20,10)
    ##RSPEC: Method Name image_by_score(x_score,y_score)
    assert_equal "role_bottom_left.png", RoleQuestion.image_by_score(16,5)
    ##RSPEC: Method Name text_and_color_by_score(x_score,y_score)
    role, color = RoleQuestion.text_and_color_by_score(1, 7)
    assert_equal "analyzer", role
    assert_not_equal "blue", color
    ##RSPEC: Method Name text_by_score(x_score,y_score)
    assert_equal "analyzer", RoleQuestion.text_by_score(9,49)
  end
end