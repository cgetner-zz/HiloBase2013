# coding: UTF-8

class CreatePromotionalCodeDetails < ActiveRecord::Migration
  def self.up
    create_table :promotional_code_details, :options => "ENGINE=InnoDB" do |t|
      t.integer :promotional_code_id
      t.string :source_name
      t.datetime :origination
      t.datetime :expiration
      t.timestamps
    end
  end

  def self.down
    drop_table :promotional_code_details
  end
end
