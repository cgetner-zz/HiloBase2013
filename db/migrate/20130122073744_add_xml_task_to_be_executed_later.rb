class AddXmlTaskToBeExecutedLater < ActiveRecord::Migration
  def self.up
    add_column :jobs, :xml_import_pairing_logic, :boolean, :default=>false
  end

  def self.down
    remove_column :jobs, :xml_import_pairing_logic
  end
end
