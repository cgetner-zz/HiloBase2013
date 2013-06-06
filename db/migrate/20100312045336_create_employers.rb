# coding: UTF-8

class CreateEmployers < ActiveRecord::Migration
  def self.up
    create_table :employers, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.integer :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :employers
  end
end
