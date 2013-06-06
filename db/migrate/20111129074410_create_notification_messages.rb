# coding: UTF-8

class CreateNotificationMessages < ActiveRecord::Migration
  def self.up
    create_table :notification_messages do |t|
	  t.string :message
      t.timestamps
    end
  end

  def self.down
    drop_table :notification_messages
  end
end
