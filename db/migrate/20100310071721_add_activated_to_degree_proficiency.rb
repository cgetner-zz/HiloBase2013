# coding: UTF-8

class AddActivatedToDegreeProficiency < ActiveRecord::Migration
  def self.up
      add_column :proficiencies,:activated,:boolean,:default=>false
      add_column :certificates,:activated,:boolean,:default=>false
      
      add_column :proficiencies,:created_by,:integer
      add_column :certificates,:created_by,:integer
  end

  def self.down
      remove_column :proficiencies,:activated
      remove_column :certificates,:activated
      
      remove_column :proficiencies,:created_by
      remove_column :certificates,:created_by
  end
end
