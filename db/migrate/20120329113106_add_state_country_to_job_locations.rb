# coding: UTF-8

class AddStateCountryToJobLocations < ActiveRecord::Migration
  def self.up
    add_column :job_locations, :state, :string
    add_column :job_locations, :country, :string
  end

  def self.down
    remove_column :job_locations, :state
    remove_column :job_locations, :country
  end
end