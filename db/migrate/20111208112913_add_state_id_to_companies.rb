# coding: UTF-8

class AddStateIdToCompanies < ActiveRecord::Migration
  def self.up
    #add_column :companies, :state_id, :integer
    execute "ALTER TABLE companies ADD COLUMN state_id INTEGER AFTER zip"
  end

  def self.down
    remove_column :companies, :state_id
  end
end
