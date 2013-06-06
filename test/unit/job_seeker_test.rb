# coding: UTF-8

require 'test_helper'

class JobSeekerTest < ActiveSupport::TestCase
  @job_seeker = FactoryGirl.build(:job_seeker)
  first_name = @job_seeker.first_name
  full_name = @job_seeker.full_name
  password = "Tabcd123"
  should "test job seeker first name" do
    job_seeker = JobSeeker.new
    ##RSPEC: Method Name validate_unique_email
    assert !job_seeker.validate_unique_email
    assert_equal "Shrikant", first_name
    ##RSPEC: Method Name full_name
    assert_equal "Shrikant Khanvilkar", full_name
    ##RSPEC: Method Name encrypted_password(pwd)
    assert_equal JobSeeker.encrypted_password(password), "7fd0a90d24e8b4f80989d32f77989fb71b4b0aa7"
  end

  describe JobSeeker do
    it { should validate_acceptance_of :terms_of_service }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of :password }
    it { should have_many(:job_seeker_links).dependent(:destroy) }
    it { should have_many(:references).dependent(:destroy)}
    it { should validate_format_of(:email).with(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) }
    it { should validate_format_of(:contact_email).with(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) }
  end
  ##TODO: Validation in case of special characters and empty strings and length should be applied on all fields
  should validate_presence_of :first_name
  should ensure_length_of(:first_name).is_at_most(30)
  should allow_value("John").for(:first_name)
  should_not allow_value("  ").for(:first_name)
  should_not allow_value("$%&&***").for(:first_name)

  should validate_presence_of :last_name
  should ensure_length_of(:last_name).is_at_most(30)
  should allow_value("Doe").for(:last_name)
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
  should have_many :pairing_logics

  should have_many(:job_seeker_desired_employments).dependent(:destroy)
  should have_many(:desired_employments).through(:job_seeker_desired_employments)

  should have_many(:job_seeker_desired_locations).dependent(:destroy)
  should have_many(:desired_locations).through(:job_seeker_desired_locations)

  should have_many(:job_seeker_certificates).dependent(:destroy)
  should have_many(:certificates).through(:job_seeker_certificates)

  should have_many(:job_seeker_proficiencies).dependent(:destroy)
  should have_many(:proficiencies).through(:job_seeker_proficiencies)

  should have_many(:job_seeker_languages).dependent(:destroy)
  should have_many(:languages).through(:job_seeker_languages)

  should have_one(:job_seeker_birkman_detail).dependent(:destroy)

  should have_many(:job_seeker_notifications).dependent(:destroy)

  should allow_value("Los Angeles").for(:city)
end