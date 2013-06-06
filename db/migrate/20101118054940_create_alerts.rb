# coding: UTF-8

class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_seeker_id
      t.text :text
      t.string :url
      t.boolean :deleted ,:default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
