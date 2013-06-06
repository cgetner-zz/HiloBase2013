# coding: UTF-8

class CreateJobSeekerDesiredLocations < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_desired_locations, :options => "ENGINE=InnoDB"  do |t|
      t.integer :job_seeker_id
      t.integer :desired_location_id
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_desired_locations
  end
end
