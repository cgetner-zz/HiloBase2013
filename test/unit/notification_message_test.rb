# coding: UTF-8

require 'test_helper'

class NotificationMessageTest < ActiveSupport::TestCase
  should have_many :job_seeker_notifications

  should allow_value("You have notifications pending").for(:message)
end