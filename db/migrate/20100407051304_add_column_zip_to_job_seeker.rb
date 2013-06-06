# coding: UTF-8

class AddColumnZipToJobSeeker < ActiveRecord::Migration
  def self.up
      add_column :job_seekers,:zip_code,:string
  end

  def self.down
    remove_column :job_seekers,:zip_code
  end
end
