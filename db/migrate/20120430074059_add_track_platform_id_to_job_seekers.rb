# coding: UTF-8

class AddTrackPlatformIdToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :track_platform_id, :integer, :default => nil
  end
end
