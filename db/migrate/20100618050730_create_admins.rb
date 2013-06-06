# coding: UTF-8

class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins, :options => "ENGINE=InnoDB" do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :hashed_password
      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
