# coding: UTF-8

class AddFollowCheckToJobSeekers < ActiveRecord::Migration
  def self.up
    add_column :job_seekers, :follow_check, :boolean, :default=>false
  end

  def self.down
    remove_column :job_seekers, :follow_check
  end
end
