# coding: UTF-8

class CreateDesiredLocations < ActiveRecord::Migration
  def self.up
    create_table :desired_locations, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :desired_locations
  end
end
