# coding: UTF-8

class AddSummaryToJobs < ActiveRecord::Migration
  def self.up
      add_column :jobs,:summary,:text
  end

  def self.down
      remove_column :jobs,:summary
  end
end
