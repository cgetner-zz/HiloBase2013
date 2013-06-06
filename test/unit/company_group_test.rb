# coding: UTF-8

require 'test_helper'

class CompanyGroupTest < ActiveSupport::TestCase
  @company_group = FactoryGirl.build(:company_group)
  category       = @company_group.name
  group_id       = @company_group.id
  company_id     = @company_group.company_id

  should "test category name" do
    assert_equal 'Developer', category
    assert_not_equal 15, category.length
    ##RSPEC: Method Name remove(company_id, group_id)
    assert CompanyGroup.remove(company_id, group_id)
  end

  describe CompanyGroup do
    it {should validate_uniqueness_of(:name).case_insensitive}
  end
  ##TODO: Validation in case of special characters and empty strings and length should be applied on all fields
  should validate_presence_of :name
  should ensure_length_of(:name).is_at_most(30)
  should_not allow_value(nil).for(:name)
  should_not allow_value("").for(:name)
  should_not allow_value("  ").for(:name)
  should_not allow_value("abcdefghijklmnopqrstuvwxyz1234ABCD").for(:name)
  should allow_value("Software Engineer").for(:name)

  should validate_presence_of :company_id
  should_not allow_value("").for(:company_id)
  should allow_value(2).for(:company_id)
  
  should have_many :jobs
end