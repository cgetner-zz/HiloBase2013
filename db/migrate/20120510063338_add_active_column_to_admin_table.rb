class AddActiveColumnToAdminTable < ActiveRecord::Migration
  def self.up
     add_column :administrators, :active, :boolean
  end

  def self.down
    remove_column :administrators, :active
  end
end
