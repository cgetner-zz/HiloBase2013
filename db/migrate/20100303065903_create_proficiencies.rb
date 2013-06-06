# coding: UTF-8

class CreateProficiencies < ActiveRecord::Migration
  def self.up
    create_table :proficiencies, :options => "ENGINE=InnoDB" do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :proficiencies
  end
end
