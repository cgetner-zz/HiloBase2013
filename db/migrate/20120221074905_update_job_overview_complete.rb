# coding: UTF-8

class UpdateJobOverviewComplete < ActiveRecord::Migration
  def self.up
	execute("UPDATE jobs SET overview_complete = 1 WHERE profile_complete = 1")
  end

  def self.down
  end
end
