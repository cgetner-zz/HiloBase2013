# coding: UTF-8

class CreateCreativeSamples < ActiveRecord::Migration
  def self.up
    create_table :creative_samples, :options => "ENGINE=InnoDB"  do |t|
      t.string :type
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.string :url,:limit=>500
      t.integer :job_seeker_id
      t.timestamps
    end
  end

  def self.down
    drop_table :creative_samples
  end
end
