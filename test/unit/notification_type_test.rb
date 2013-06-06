# coding: UTF-8

require 'test_helper'

class NotificationTypeTest < ActiveSupport::TestCase
  should have_many :job_seeker_notifications
end