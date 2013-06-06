# coding: UTF-8

class CreatePairingLogics < ActiveRecord::Migration
  def self.up
    create_table :pairing_logics do |t|
      t.integer :job_seeker_id
      t.integer :job_id
      t.float :pairing_value

      t.timestamps
    end
  end

  def self.down
    drop_table :pairing_logics
  end
end
