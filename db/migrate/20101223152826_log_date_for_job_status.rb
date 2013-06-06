# coding: UTF-8

class LogDateForJobStatus < ActiveRecord::Migration
  def self.up
      add_column :job_statuses, :considered_on,:datetime
      add_column :job_statuses, :interested_on,:datetime
      add_column :job_statuses, :wildcard_on,:datetime
      add_column :job_statuses, :read_on,:datetime
      
  end

  def self.down
      remove_column :job_statuses, :considered_on
      remove_column :job_statuses, :interested_on
      remove_column :job_statuses, :wildcard_on
      remove_column :job_statuses, :read_on
  end
end
