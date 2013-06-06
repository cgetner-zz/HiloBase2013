# coding: UTF-8

class AreYouSureFieldInDataBase < ActiveRecord::Migration
  def self.up
	add_column :employers, :advanced_alert, :boolean, :default => false
	add_column :job_seekers, :advanced_alert, :boolean, :default => false
  end

  def self.down
	remove_column :employers, :advanced_alert
	remove_column :job_seekers, :advanced_alert
  end
end
