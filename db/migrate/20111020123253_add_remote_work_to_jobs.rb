# coding: UTF-8

class AddRemoteWorkToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :remote_work, :boolean
  end

  def self.down
    remove_column :jobs, :remote_work
  end
end
