# coding: UTF-8

class AddRecipientNameToGift < ActiveRecord::Migration
  def self.up
      add_column :gifts,:recipient_name,:string
  end

  def self.down
      remove_column :gifts,:recipient_name
  end
end
