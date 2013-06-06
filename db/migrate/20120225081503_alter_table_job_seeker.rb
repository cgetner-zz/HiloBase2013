# coding: UTF-8

class AlterTableJobSeeker < ActiveRecord::Migration
  def self.up
     change_column :job_seekers, :js_admin,:integer, :default=> nil
  end

  def self.down
    change_column :job_seekers, :js_admin,:string, :default=> nil
  end
end
