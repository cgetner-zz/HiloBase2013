# coding: UTF-8

class CreateReferences < ActiveRecord::Migration
  def self.up
    create_table :references, :options => "ENGINE=InnoDB"  do |t|
      t.string :name
      t.string :position
      t.string :company
      t.string :email
      t.text :comments
      t.integer :job_seeker_id
      
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      
      t.timestamps
    end
  end

  def self.down
    drop_table :references
  end
end
