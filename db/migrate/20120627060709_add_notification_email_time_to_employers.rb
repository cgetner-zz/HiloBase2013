class AddNotificationEmailTimeToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :notification_email_time, :datetime
  end
end
