# coding: UTF-8

class AddTrackSharedJobIdToJobSeeker < ActiveRecord::Migration
  def change
    add_column :job_seekers, :track_shared_job_id, :string, :default => nil
  end
end
