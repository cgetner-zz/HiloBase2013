# coding: UTF-8

class CreateJobSeekerAwards < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_awards, :options => "ENGINE=InnoDB"  do |t|
      t.integer :job_seeker_id
      t.string :title,:limit=>500
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_awards
  end
end
