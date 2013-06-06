# coding: UTF-8

class CreateJobSeekerWatchlists < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_watchlists do |t|
      t.integer :job_seeker_id
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_watchlists
  end
end
