# coding: UTF-8

class AddJobIdToPurchasedProfiles < ActiveRecord::Migration
  def self.up
    add_column :purchased_profiles, :job_id, :integer, :default => nil
  end

  def self.down
    remove_column :purchased_profiles, :job_id
  end
end
