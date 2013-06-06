# coding: UTF-8

class AddArchivedInJobStatus < ActiveRecord::Migration
  def self.up
      add_column :job_statuses, :archived, :boolean, :default => false
  end

  def self.down
    remove_column :job_statuses, :archived
  end
end
