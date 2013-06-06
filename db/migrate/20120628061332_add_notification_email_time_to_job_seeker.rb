class AddNotificationEmailTimeToJobSeeker < ActiveRecord::Migration
  def change
    add_column :job_seekers, :notification_email_time, :datetime
  end
end
