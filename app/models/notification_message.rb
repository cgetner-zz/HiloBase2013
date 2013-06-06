# coding: UTF-8

class NotificationMessage < ActiveRecord::Base
  attr_accessible :message, :link
  has_many :job_seeker_notifications
end
