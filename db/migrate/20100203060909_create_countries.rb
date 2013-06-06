# coding: UTF-8

class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.string :alpha2
      t.string :alpha3
      t.integer :numeric
      t.timestamps
    end
  end

  def self.down
    drop_table :countries
  end
end
