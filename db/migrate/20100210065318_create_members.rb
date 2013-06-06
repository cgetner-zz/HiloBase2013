# coding: UTF-8

class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
