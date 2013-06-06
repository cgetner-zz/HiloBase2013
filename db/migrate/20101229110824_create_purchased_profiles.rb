# coding: UTF-8

class CreatePurchasedProfiles < ActiveRecord::Migration
  def self.up
    create_table :purchased_profiles do |t|
      t.integer :job_seeker_id
      t.integer :employer_id
      t.integer :payment_id
      t.timestamps
    end
  end

  def self.down
    drop_table :purchased_profiles
  end
end
