# coding: UTF-8

class CreateJobCriteriaDesiredLocations < ActiveRecord::Migration
  def self.up
    create_table :job_criteria_desired_locations do |t|
      t.integer :job_id
      t.integer :desired_location_id
      t.timestamps
    end
  end

  def self.down
    drop_table :job_criteria_desired_locations
  end
end
