# coding: UTF-8

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  @company = FactoryGirl.build(:company)
  company_name = @company.name

  should "test company name" do
    assert_not_equal "11111", company_name
    assert_equal "Hilo Inc.", company_name
  end

  describe Company do
    it {should validate_uniqueness_of(:name).case_insensitive}
  end

  should have_many :employers
  should have_many :jobs
  should belong_to :owner_ship_type
  ##TODO: Validation in case of special characters and empty strings and length should be applied on all fields
  should validate_presence_of :name
  should ensure_length_of(:name).is_at_most(30)
  should_not allow_value(nil).for(:name)
  should allow_value("The Company Inc.").for(:name)
  should_not allow_value("  ").for(:name)
  should_not allow_value("@^&*&*").for(:name)
  should_not allow_value("fgsdgfdjgh uierhgtuihrguihdfighdf hfgjuidfhg").for(:name)

  should_not allow_value("www.twitter.com/hilo").for(:facebook_link)
  should_not allow_value("sdfgsjgshduftergfbh fsdhfjbhf tgryue").for(:facebook_link)
  should allow_value("").for(:facebook_link)

  should allow_value("www.twitter.com/hilo").for(:twitter_link)
  should_not allow_value("sdfgsjgshduftergfbh fsdhfjbhf tgryue").for(:twitter_link)
  should allow_value("www.twitter.com/hilo").for(:twitter_link)
  should allow_value("").for(:twitter_link)

  should allow_value("").for(:other_link_one)

  should allow_value("").for(:other_link_two)
end