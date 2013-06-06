class AddJobActivityChangesIntoEmployerAlerts < ActiveRecord::Migration
  def self.up
    add_column :employer_alerts, :employer_job_activity, :integer
    remove_column :jobs, :is_updated
  end

  def self.down
    remove_column :employer_alerts, :employer_job_activity
    add_column :jobs, :is_updated, :boolean
  end
end