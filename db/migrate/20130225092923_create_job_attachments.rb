class CreateJobAttachments < ActiveRecord::Migration
  def change
    create_table :job_attachments do |t|
      t.integer :job_id
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.string :attachment_title
      t.timestamps
    end
  end
end
