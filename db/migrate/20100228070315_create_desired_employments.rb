# coding: UTF-8

class CreateDesiredEmployments < ActiveRecord::Migration
  def self.up
    create_table :desired_employments, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :desired_employments
  end
end
