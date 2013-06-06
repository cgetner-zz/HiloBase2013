# coding: UTF-8

class CreateGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts, :options => "ENGINE=InnoDB" do |t|
      
      t.string :sender_name
      t.string :sender_email
      t.string :recipient_email
      t.text :mail_text
      
      t.timestamps
    end
  end

  def self.down
    drop_table :gifts
  end
end
