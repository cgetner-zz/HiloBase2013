# coding: UTF-8

class AddNewToJobSeekerNotifications < ActiveRecord::Migration
  def self.up
    add_column :job_seeker_notifications, :new, :boolean, :default => true
  end

  def self.down
    remove_column :job_seeker_notifications, :new
  end
end
