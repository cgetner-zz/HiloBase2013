# coding: UTF-8

class CreateProfileResponsibilities < ActiveRecord::Migration
  def self.up
    create_table :profile_responsibilities, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_responsibilities
  end
end
