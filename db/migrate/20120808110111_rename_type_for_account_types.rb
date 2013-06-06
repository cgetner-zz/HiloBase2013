class RenameTypeForAccountTypes < ActiveRecord::Migration
  def up
    #rename_column :account_types, :type, :account_type
  end

  def down
    #rename_column :account_types, :account_type, :type
  end
end
