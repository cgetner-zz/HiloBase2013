# coding: UTF-8

require 'test_helper'

class EmployerTest < ActiveSupport::TestCase
  @employer = FactoryGirl.build(:employer)
  email = @employer.email
  password = "Tabcd123"

  should "test employer email" do
    assert_equal 'genipher@thehiloproject.com', email
    
    @emp = Employer.new
    ##RSPEC: Method Name fetch_alerts
    assert @emp.fetch_alerts
    ##RSPEC: Method Name create_or_get_companygroup
    company_groups = @emp.create_or_get_companygroup('Developer')
    category_name = company_groups.first.name
    ##RSPEC: Method Name validate_unique_email
    assert !@emp.validate_unique_email
    ##RSPEC: Method Name set_company_id_if_empty(company_id)
    assert @emp.set_company_id_if_empty(1)
    ##RSPEC: Method Name encrypted_password(login_pass)
    assert_equal Employer.encrypted_password(password), "7fd0a90d24e8b4f80989d32f77989fb71b4b0aa7"
    assert_equal @emp.errors[:email].count, 0
    assert_not_equal @emp.errors[:email].count, 1
    assert_not_equal @emp.errors[:email].count, "one"
    assert_equal 'Developer', category_name
    assert_not_equal 345, category_name
    assert_not_equal "$#*&", category_name
  end
  
  describe Employer do
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_acceptance_of :terms_of_service }
    it { should validate_confirmation_of :password }
    it { should validate_format_of(:email).with(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)}
  end
  ##TODO: Validation in case of special characters and empty strings and length should be applied on all fields
  should validate_presence_of :first_name
  should ensure_length_of(:first_name).is_at_most(30)
  should_not allow_value(nil).for(:first_name)
  should allow_value("George").for(:first_name)
  should_not allow_value("  ").for(:first_name)
  should_not allow_value("$%&&***").for(:first_name)

  should validate_presence_of :last_name
  should ensure_length_of(:last_name).is_at_most(30)
  should allow_value("Thomus").for(:last_name)
  should_not allow_value(" ").for(:last_name)
  should_not allow_value(nil).for(:last_name)
  should_not allow_value("-*$%&&*").for(:first_name)

  should_not allow_value("abcdefghijklmnopqrstuvwxyz123ABCD").for(:password)
  should_not allow_value("  ").for(:password)

  should validate_presence_of :email
  should ensure_length_of(:email).is_at_most(75)
  should_not allow_value(nil).for(:email)
  should_not allow_value("email id").for(:email)
  should allow_value("george.thomus@thehiloproject.com").for(:email)
  should_not allow_value("george.thomus@thehilopguilguiguigiguiguiguigui567576576567557576567guiguiguiguiguiguiguiguiguiguiroject.com").for(:email)
  should_not allow_value("   ").for(:email)
  
  should have_many :payments
  should have_many :jobs
  should belong_to :company

  should allow_value(1).for(:company_id)
end