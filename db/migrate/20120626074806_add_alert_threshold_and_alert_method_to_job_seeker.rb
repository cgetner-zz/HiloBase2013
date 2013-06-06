class AddAlertThresholdAndAlertMethodToJobSeeker < ActiveRecord::Migration
  def change
    add_column :job_seekers, :alert_threshold, :integer, :default => 3
    add_column :job_seekers, :alert_method, :integer, :default => 1
  end
end
