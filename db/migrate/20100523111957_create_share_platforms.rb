# coding: UTF-8

class CreateSharePlatforms < ActiveRecord::Migration
  def self.up
    create_table :share_platforms, :options => "ENGINE=InnoDB" do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :share_platforms
  end
end
