# coding: UTF-8

class AddLinkToNotificationMessages < ActiveRecord::Migration
  def self.up
    add_column :notification_messages, :link, :string, :default => "javascript:void(0)"
	
  end

  def self.down
    remove_column :notification_messages, :link
  end
end
