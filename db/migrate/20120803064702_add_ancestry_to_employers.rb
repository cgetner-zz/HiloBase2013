class AddAncestryToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :ancestry, :string
    add_index :employers, :ancestry
  end
end
