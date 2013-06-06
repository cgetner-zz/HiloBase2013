# coding: UTF-8

class CreateJobSeekerNotifications < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_notifications do |t|
	  t.integer :job_seeker_id
	  t.integer :notification_type_id
	  t.integer :notification_message_id
	  t.boolean :visibility
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_notifications
  end
end
