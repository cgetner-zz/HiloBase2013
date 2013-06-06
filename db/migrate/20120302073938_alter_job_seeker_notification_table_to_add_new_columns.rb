# coding: UTF-8

class AlterJobSeekerNotificationTableToAddNewColumns < ActiveRecord::Migration
  def self.up
	add_column :job_seeker_notifications, :job_id,:integer, :default=> nil
	add_column :job_seeker_notifications, :company_id,:integer, :default=> nil
  end

  def self.down
  end
end
