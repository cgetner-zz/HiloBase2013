# coding: UTF-8

require 'test_helper'

class JobSeekerBirkmanDetailTest < ActiveSupport::TestCase
  @js_birkman_detail = FactoryGirl.build(:job_seeker_birkman_detail)
  flag = @js_birkman_detail.score_fetched?
  character = JobSeekerBirkmanDetail.alphabet_by_num(0)
  should belong_to :job_seeker
  
  should allow_value(1).for(:job_seeker_id)

  should "test methods in model" do
    ##RSPEC: Method Name score_fetched?
    assert !flag
    ##RSPEC: Method Name alphabet_by_num(num)
    assert_equal "A", character
  end
end