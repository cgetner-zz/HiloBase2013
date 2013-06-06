# coding: UTF-8

class CreateOwnerShipTypes < ActiveRecord::Migration
  def self.up
    create_table :owner_ship_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :owner_ship_types
  end
end
