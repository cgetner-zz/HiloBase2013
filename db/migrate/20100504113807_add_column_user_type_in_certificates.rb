# coding: UTF-8

class AddColumnUserTypeInCertificates < ActiveRecord::Migration
  def self.up
    add_column :certificates,:user_type,:string 
  end

  def self.down
    remove_column :certificates,:user_type
  end
end
