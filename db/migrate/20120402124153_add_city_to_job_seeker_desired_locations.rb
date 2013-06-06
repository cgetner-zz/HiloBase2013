# coding: UTF-8

class AddCityToJobSeekerDesiredLocations < ActiveRecord::Migration
  def self.up
    add_column :job_seeker_desired_locations, :city, :string
  end

  def self.down
    remove_column :job_seeker_desired_locations, :city
  end
end
