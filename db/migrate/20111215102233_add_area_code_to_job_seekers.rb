# coding: UTF-8

class AddAreaCodeToJobSeekers < ActiveRecord::Migration
  def self.up
    add_column :job_seekers, :area_code, :string
  end

  def self.down
    remove_column :job_seekers, :area_code
  end
end
