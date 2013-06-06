# coding: UTF-8

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  @job = FactoryGirl.build(:job)
  opening = @job.name
  id = @job.id
  employer_id = @job.employer_id
  job_code = @job.auto_generate_job_code
  should "test job id, name and employer id" do
    assert_equal 'Software Engineer', opening
    assert_not_equal 223, id
    assert_equal 2, employer_id
    ##RSPEC: Method Name auto_generate_job_code
    assert job_code
    ##RSPEC: Method Name sorting_dashboard
    assert Job.sorting_dashboard("fit", "Desc")
  end
  
  describe Job do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:summary) }
    it { should validate_presence_of(:company_id) }
    it { should validate_presence_of(:employer_id) }
    it { should validate_presence_of(:company_group_id) }
    it { should validate_uniqueness_of(:code).case_insensitive }
    it { should have_many(:job_criteria_desired_locations).dependent(:destroy) }
  end

  should belong_to :job_location
  should belong_to :company_group
  should belong_to :company
  should belong_to :employer

  should have_many(:job_criteria_desired_employments).dependent(:destroy)
  should have_many(:desired_employments).through(:job_criteria_desired_employments)
  should have_many(:pairing_logics)
  should have_many(:desired_locations).through(:job_criteria_desired_locations)
  should have_many(:job_criteria_certificates).dependent(:destroy)
  should have_many(:certificates).through(:job_criteria_certificates)
  should have_many(:job_criteria_proficiencies).dependent(:destroy)
  should have_many(:proficiencies).through(:job_criteria_proficiencies)
  should have_many(:job_criteria_languages).dependent(:destroy)
  should have_many(:languages).through(:job_criteria_languages)
  should have_many(:job_workenv_questions).dependent(:destroy)
  should have_many(:job_role_questions).dependent(:destroy)
  should have_many(:job_profile_responsibilities).dependent(:destroy)
  should have_many(:profile_responsibilities).through(:job_profile_responsibilities)
  should have_one(:channel_manager).dependent(:destroy)
  ##TODO: Validation in case of special characters and empty strings and length should be applied on all fields
  should validate_presence_of(:name)
  should ensure_length_of(:name).is_at_most(60)
  should allow_value("Software Engineer").for(:name)
  should_not allow_value("   ").for(:name)
  should_not allow_value("").for(:name)
  should_not allow_value("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff").for(:name)
  
  should validate_presence_of(:summary)
  should ensure_length_of(:summary).is_at_most(550)
  should allow_value("description of position").for(:summary)
  should_not allow_value("").for(:summary)
  should_not allow_value("    ").for(:summary)
  should_not allow_value("george.thomus@thehilopguilffffffffffffffffffffffffffffffffffffffffguiguigiguiguiguiguiguiguiguig.comgeorge.thomus@thehilopguilffffffffffffffffffffffffffffffffffffffffguiguigiguiguiguiguiguiguiguig.comgeorge.thomus@thehilopguilffffffffffffffffffffffffffffffffffffffffguiguigiguiguiguiguiguiguiguig.comgeorge.thomus@thehilopguilffffffffffffffffffffffffffffffffffffffffguiguigiguiguiguiguiguiguiguig.comgeorge.thomus@thehilopguilffffffffffffffffffffffffffffffffffffffffguiguigiguiguiguiguiguiguiguig.comgeorge.thomus@thehilopguilffffffffffffffffffffffffffffffffffffffffguiguigiguiguiguiguiguiguiguig.com").for(:summary)
  
  should validate_presence_of(:company_id)
  should allow_value(1).for(:company_id)

  should validate_presence_of(:employer_id)
  should allow_value(1).for(:employer_id)

  should validate_presence_of(:company_group_id)
  should allow_value(1).for(:company_group_id)
end