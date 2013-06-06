class AddDeletedEmployerIdToEmployerAlerts < ActiveRecord::Migration
  def change
    add_column :employer_alerts, :deleted_employer_id, :integer
  end
end
