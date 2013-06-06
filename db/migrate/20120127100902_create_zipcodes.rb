# coding: UTF-8

class CreateZipcodes < ActiveRecord::Migration
  def self.up
    create_table :zipcodes do |t|
      t.integer :zip
      t.string :zipcodetype
      t.string :city
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :zipcodes
  end
end
