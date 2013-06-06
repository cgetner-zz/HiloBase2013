# coding: UTF-8

class MediaColumnsToJobSeeker < ActiveRecord::Migration
  def self.up
    add_column :job_seekers,:video_url,:string
    add_column :job_seekers,:summary,:text
    add_column :job_seekers,:preferred_contact,:string
    add_column :job_seekers, :photo_file_name, :string # Original filename
    add_column :job_seekers, :photo_content_type, :string # Mime type
    add_column :job_seekers, :photo_file_size, :integer # File size in bytes
  end

  def self.down
    remove_column :job_seekers,:video_url
    remove_column :job_seekers,:image_name
    remove_column :job_seekers,:summary
    remove_column :job_seekers,:preferred_contact
  end
end
