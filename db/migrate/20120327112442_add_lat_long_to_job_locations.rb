# coding: UTF-8

class AddLatLongToJobLocations < ActiveRecord::Migration
  def self.up
    add_column :job_locations, :latitude, :float
    add_column :job_locations, :longitude, :float
  end

  def self.down
    remove_column :job_locations, :latitude
    remove_column :job_locations, :longitude
  end
end
