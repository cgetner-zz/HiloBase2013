# coding: UTF-8

class AddCityToJobSeekers < ActiveRecord::Migration
  def self.up
    add_column :job_seekers, :city, :string
  end

  def self.down
    remove_column :job_seekers, :city
  end
end
