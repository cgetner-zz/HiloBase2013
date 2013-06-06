class AddColumnsToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :account_type_id, :integer
    add_column :employers, :deleted, :boolean, :default=>false
    add_column :employers, :suspended, :boolean, :default=>false
    add_column :employers, :tree_suspended, :boolean, :default=>false
  end
end
