# coding: UTF-8

class AddColumnToJobSeeker < ActiveRecord::Migration
  def self.up
    add_column :job_seekers, :js_admin,:string, :default=> nil
  end

  def self.down
    remove_column :job_seekers, :js_admin
  end
end
