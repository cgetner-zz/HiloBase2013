class AddAlertThresholdToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :alert_threshold, :integer, :default=>3
  end
end
