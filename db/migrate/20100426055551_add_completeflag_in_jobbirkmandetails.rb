# coding: UTF-8

class AddCompleteflagInJobbirkmandetails < ActiveRecord::Migration
  def self.up
      add_column :job_seeker_birkman_details,:test_complete,:boolean,:default=>false
  end

  def self.down
      remove_column :job_seeker_birkman_details,:test_complete
  end
end
