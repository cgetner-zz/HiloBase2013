class UpdateAlertMethodJobSeekerAndJob < ActiveRecord::Migration
  def up
    execute("UPDATE job_seekers SET alert_method = 4")
    execute("UPDATE employers SET alert_method = 4")
  end

  def down
  end
end
