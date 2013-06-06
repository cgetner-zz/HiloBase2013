# coding: UTF-8

class AddAttachmentToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :attachment_file_name, :string
    add_column :jobs, :attachment_file_size, :integer
    add_column :jobs, :attachment_content_type, :string
    add_column :jobs, :attachment_title, :string
  end

  def self.down
    remove_column :jobs, :attachment_title
    remove_column :jobs, :attachment_content_type
    remove_column :jobs, :attachment_file_size
    remove_column :jobs, :attachment_file_name
  end
end
