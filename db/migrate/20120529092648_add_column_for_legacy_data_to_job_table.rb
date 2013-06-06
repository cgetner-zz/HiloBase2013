class AddColumnForLegacyDataToJobTable < ActiveRecord::Migration
  def change
    add_column :jobs, :deactivated_for_new_credential, :boolean, :default=>nil
  end
end
