# coding: UTF-8

class CreateEmployerAlerts < ActiveRecord::Migration
  def self.up
    create_table :employer_alerts do |t|
      
      t.integer :job_id
      t.integer :job_seeker_id
      t.string :purpose
      t.boolean :read
      t.timestamps
    end
  end

  def self.down
    drop_table :employer_alerts
  end
end
