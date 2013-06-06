# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'spec_helper'

describe JobSeeker do
  context "when first created" do
    it "should be empty" do
      job_seeker = JobSeeker.new
      job_seeker.first_name.should be_nil
      job_seeker.last_name.should be_nil
      job_seeker.email.should be_nil
      job_seeker.hashed_password.should be_nil
      job_seeker.phone_one.should be_nil
      job_seeker.area_code.should be_nil
      job_seeker.contact_email.should be_nil
      job_seeker.armed_forces.should be_false
      job_seeker.follow_check.should be_false
      job_seeker.advanced_alert.should be_false
      job_seeker.preferred_contact.should be_nil
      job_seeker.completed_registration_step.should be_nil
      job_seeker.activated.should be_false
    end

    it "can be instantiated" do
      JobSeeker.new.should be_an_instance_of(JobSeeker)
    end
  end
end

describe JobSeeker do
  context "basic job seeker" do
    before(:each) do
      @job_seeker = FactoryGirl.build(:job_seeker)
    end

    describe "basic job seeker validations" do
      it "first name cannot be null" do
        job_seeker = FactoryGirl.build(:job_seeker, :first_name=>"")
        job_seeker.should_not be_valid
        job_seeker.errors[:first_name].should include("can't be blank")
        job_seeker.first_name = "Sambit"
        job_seeker.should be_valid
      end

      it "last name cannot be null" do
        job_seeker = FactoryGirl.build(:job_seeker, :last_name=>"")
        job_seeker.should_not be_valid
        job_seeker.errors[:last_name].should include("can't be blank")
        job_seeker.last_name = "Dutta"
        job_seeker.should be_valid
      end

      it "email cannot be null" do
        job_seeker = FactoryGirl.build(:job_seeker, :email=>"")
        job_seeker.email.should_not match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
        job_seeker.should_not be_valid
        job_seeker.errors[:email].should include("can't be blank")
        job_seeker.email = "sambydutt@gmail.com"
        job_seeker.email.should match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
        job_seeker.should be_valid
      end

      it "password cannot be null" do
        job_seeker = FactoryGirl.build(:job_seeker, :password=>"")
        job_seeker.password.should_not match(/^[a-z0-9]+$/i)
        job_seeker.should_not be_valid
        job_seeker.errors[:password].should include("can't be blank")
        job_seeker.password = "testing"
        job_seeker.password.should match(/^[a-z0-9]+$/i)
        job_seeker.should be_valid
      end
      
    end
    
    it "should validate unique email" do
      @job_seeker.email.should satisfy{ |eml|
        JobSeeker.where(:email => eml).first.nil?
      }
    end

  end
end

describe JobSeeker do
  context "authentication for" do
    before(:each) do
      @job_seeker = FactoryGirl.create(:job_seeker)
    end

    it "valid user" do
      @job_seeker.email = "aa@aa.com"
      @job_seeker.should_not satisfy{ |js|
        !JobSeeker.authenticate_job_seeker(js.email, js.password).nil? #true
      }
      @job_seeker.email = "sambydutt@gmail.com"
      @job_seeker.should satisfy{ |js|
        !JobSeeker.authenticate_job_seeker(js.email, js.password).nil? #false
      }
    end
  end

  context "add languages" do
    before(:each) do
      @job_seeker = FactoryGirl.create(:job_seeker)
      FactoryGirl.create(:language)
      FactoryGirl.create(:language, :id=>2, :name=>"French")
      FactoryGirl.create(:language, :id=>3, :name=>"Hindi")
      FactoryGirl.create(:language, :id=>4, :name=>"French")
      FactoryGirl.create(:language, :id=>5, :name=>"Latin")
      FactoryGirl.create(:language, :id=>6, :name=>"Spanish")
    end

    it "should have many languages" do
      js = JobSeeker.reflect_on_association(:languages)
      js.macro.should == :has_many
    end

    it "check functionality" do
      lang_string = "French__a,Hindi__c,Spanish__a"
      @job_seeker.add_languages_new(lang_string)
      lang_ids = []
      lang = lang_string.split(",")
      lang.each{ |l|
        lang_ids<<Language.where(:name=>l.split("__")[0]).first.id
      }
      job_seeker_languages = []
      JobSeekerLanguage.where(:job_seeker_id=>@job_seeker.id).each{ |jsl|
        job_seeker_languages<<jsl.language_id
      }
      lang_ids.each{ |l|
        job_seeker_languages.should include(l)
      }
    end
  end
end



