# coding: UTF-8

class AddStateToCompanyTable < ActiveRecord::Migration
  def self.up
    add_column :companies, :state, :string, :default => nil
  end
  
  def self.down
    remove_column :companies, :state
  end
end
