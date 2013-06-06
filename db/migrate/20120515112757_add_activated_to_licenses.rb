class AddActivatedToLicenses < ActiveRecord::Migration
  def change
    rename_table :Licenses, :licenses
    add_column :licenses, :activated, :boolean, :default=>true
  end
end
