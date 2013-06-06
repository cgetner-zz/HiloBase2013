# coding: UTF-8

class AddArmedForcesToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :armed_forces, :boolean, :default => true
  end

  def self.down
    remove_column :jobs, :armed_forces
  end
end
