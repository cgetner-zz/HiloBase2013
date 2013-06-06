# coding: UTF-8

class AddPincodeToJobSeekerDesiredLocations < ActiveRecord::Migration
  def self.up
	add_column :job_seeker_desired_locations, :pincode, :string, :default => nil
  end

  def self.down
	remove_column :job_seeker_desired_locations, :pincode
  end
end
