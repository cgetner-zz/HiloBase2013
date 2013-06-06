# coding: UTF-8

class AddLatLongToJobSeekerDesiredLocations < ActiveRecord::Migration
  def self.up
    add_column :job_seeker_desired_locations, :latitude, :float
    add_column :job_seeker_desired_locations, :longitude, :float
  end

  def self.down
    remove_column :job_seeker_desired_locations, :latitude
    remove_column :job_seeker_desired_locations, :longitude
  end
end
