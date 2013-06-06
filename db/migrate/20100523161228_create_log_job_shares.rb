# coding: UTF-8

class CreateLogJobShares < ActiveRecord::Migration
  def self.up
    create_table :log_job_shares, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_id
      t.integer :share_platform_id
      t.integer :job_seeker_id

      t.timestamps
    end
  end

  def self.down
    drop_table :log_job_shares
  end
end
