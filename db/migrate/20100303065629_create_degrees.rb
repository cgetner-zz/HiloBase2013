# coding: UTF-8

class CreateDegrees < ActiveRecord::Migration
  def self.up
    create_table :degrees, :options => "ENGINE=InnoDB" do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :degrees
  end
end
