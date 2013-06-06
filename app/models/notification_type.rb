# coding: UTF-8

class NotificationType < ActiveRecord::Base
  attr_accessible :name
 has_many :job_seeker_notifications
end
