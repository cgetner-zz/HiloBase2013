class AlterTableEmployerAlertsAddEmployerId < ActiveRecord::Migration
  def up
    add_column :employer_alerts, :employer_id, :integer, :limit => 8
  end

  def down
    remove_column :employer_alerts, :employer_id
  end
end
