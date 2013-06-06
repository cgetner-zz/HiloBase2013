# coding: UTF-8

require 'test_helper'

class CoderequestTest < ActiveSupport::TestCase
  describe Coderequest do
    it { should validate_uniqueness_of(:email).case_insensitive}
    it { should validate_format_of(:email).with(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) }
  end
  
  should validate_presence_of :email
  should_not allow_value("abc").for(:email)
  should_not allow_value(nil).for(:email)
  should allow_value("abc@rediff.com").for(:email)
end