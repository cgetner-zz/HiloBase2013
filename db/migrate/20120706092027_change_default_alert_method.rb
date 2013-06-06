class ChangeDefaultAlertMethod < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("ALTER TABLE job_seekers CHANGE `alert_method` `alert_method` INT DEFAULT 4;")
    ActiveRecord::Base.connection.execute("ALTER TABLE employers CHANGE `alert_method` `alert_method` INT DEFAULT 4;")
  end

  def down
  end
end
