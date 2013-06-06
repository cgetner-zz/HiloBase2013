# coding: UTF-8

class CreateJobLocations < ActiveRecord::Migration
  def self.up
    create_table :job_locations, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.integer :country_id
      t.timestamps
    end
  end

  def self.down
    drop_table :job_locations
  end
end
