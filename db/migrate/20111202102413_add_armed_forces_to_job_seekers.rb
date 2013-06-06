# coding: UTF-8

class AddArmedForcesToJobSeekers < ActiveRecord::Migration
  def self.up
    add_column :job_seekers, :armed_forces, :boolean, :default => false
  end

  def self.down
    remove_column :job_seekers, :armed_forces
  end
end
