class AddFNameLNameToAdminTable < ActiveRecord::Migration
  def self.up
     add_column :administrators, :first_name, :string
     add_column :administrators, :last_name, :string
  end

  def self.down
    remove_column :administrators, :first_name
    remove_column :administrators, :last_name
  end
end
