class AddIsMigrationIntoCorporateAccounts < ActiveRecord::Migration
  def up
    add_column :corporate_accounts, :is_approved, :boolean, :default => 0
  end

  def down
    remove_column :corporate_accounts, :is_approved
  end
end
