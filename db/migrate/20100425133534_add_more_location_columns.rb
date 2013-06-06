# coding: UTF-8

class AddMoreLocationColumns < ActiveRecord::Migration
  def self.up
      add_column :job_locations,:street_one,:string
      add_column :job_locations,:street_two,:string
      add_column :job_locations,:city,:string
      add_column :job_locations,:zip_code,:string
      
  end

  def self.down
      remove_column :job_locations,:street_one
      remove_column :job_locations,:street_two
      remove_column :job_locations,:city
      remove_column :job_locations,:zip_code
  end
end
