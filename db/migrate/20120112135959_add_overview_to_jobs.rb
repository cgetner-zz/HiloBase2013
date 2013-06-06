# coding: UTF-8

class AddOverviewToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :overview, :text
  end

  def self.down
    remove_column :jobs, :overview
  end
end
