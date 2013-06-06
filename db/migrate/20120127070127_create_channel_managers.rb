# coding: UTF-8

class CreateChannelManagers < ActiveRecord::Migration
  def self.up
    create_table :channel_managers do |t|
      t.integer :job_id
      t.integer :facebook_count, :default=>0
      t.integer :linkedin_count, :default=>0
      t.integer :twitter_count, :default=>0
      t.integer :url_count, :default=>0
      t.integer :hilo_count, :default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :channel_managers
  end
end
