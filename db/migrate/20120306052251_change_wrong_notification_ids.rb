# coding: UTF-8

class ChangeWrongNotificationIds < ActiveRecord::Migration
  def self.up
	changes = JobSeekerNotification.find(:all, :conditions=>["notification_type_id = ? and notification_message_id = ?",3,6])
	if not changes.nil?
		for change in changes
			change.notification_message_id=5
			change.save
		end
	end
	changes = JobSeekerNotification.find(:all, :conditions=>["notification_type_id = ? and notification_message_id = ?",3,7])
	if not changes.nil?
		for change in changes
			change.notification_message_id=6
			change.save
		end
	end
  end

  def self.down
  end
end
