# coding: UTF-8

require 'test_helper'

class JobSeekerNotificationTest < ActiveSupport::TestCase
  should belong_to :job_seeker
  should belong_to :notification_message
  should belong_to :notification_type
  should belong_to :job
  should belong_to :company
end