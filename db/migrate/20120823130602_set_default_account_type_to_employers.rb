class SetDefaultAccountTypeToEmployers < ActiveRecord::Migration
  def up
    change_column_default(:employers, :account_type_id, 3)
  end

  def down
  end
end
