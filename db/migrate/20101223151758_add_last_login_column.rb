# coding: UTF-8

class AddLastLoginColumn < ActiveRecord::Migration
  def self.up
      add_column :employers,:last_login,:datetime
      add_column :job_seekers,:last_login,:datetime
  end

  def self.down
      remove_column :employers,:last_login
      remove_column :job_seekers,:last_login
  end
end
