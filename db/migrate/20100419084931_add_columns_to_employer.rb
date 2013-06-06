# coding: UTF-8

class AddColumnsToEmployer < ActiveRecord::Migration
  def self.up
       
       add_column :employers, :first_name,:string
       add_column :employers, :last_name,:string
       add_column :employers, :email,:string
       add_column :employers, :hashed_password,:string
       add_column :employers, :phone_one,:string
       add_column :employers, :phone_two,:string
       add_column :employers, :contact_email,:string
       add_column :employers, :zip_code,:string
       add_column :employers, :preferred_contact,:string
       add_column :employers, :completed_registration_step,:integer
       
       add_column :employers, :activated,:boolean, :default=> false
       
       remove_column :employers, :name
  end

  def self.down
       remove_column :employers, :first_name
       remove_column :employers, :last_name
       remove_column :employers, :email
       remove_column :employers, :hashed_password
       remove_column :employers, :phone_one
       remove_column :employers, :phone_two
       remove_column :employers, :zip_code
       remove_column :employers, :preferred_contact
       remove_column :employers, :activated
       remove_column :employers, :completed_registration_step
       
       add_column :employers, :name,:string 
  end
end
