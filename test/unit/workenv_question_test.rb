# coding: UTF-8

require 'test_helper'

class WorkenvQuestionTest < ActiveSupport::TestCase
   should "test methods in model" do
     ##RSPEC: Method Name section_by_score(x_score,y_score)
     assert_equal "top_left", WorkenvQuestion.section_by_score(10,52)
     assert_not_equal "top_right", WorkenvQuestion.section_by_score(52,10)

     ##RSPEC: Method Name image_by_score(x_score,y_score)
     assert_equal "workenv_bottom_left.png", WorkenvQuestion.image_by_score(10,20)

     ##RSPEC: Method Name text_and_color_by_score(x_score,y_score)
     role, color = WorkenvQuestion.text_and_color_by_score(10,20)
     assert_equal "analyzer", role
     assert_equal "yellow", color
     
     ##RSPEC: Method Name text_by_score(x_score,y_score)
     assert_equal "doer", WorkenvQuestion.text_by_score(10,52)
   end  
end