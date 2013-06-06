class AddRequestDeletedToJobSeeker < ActiveRecord::Migration
  def change
    add_column :job_seekers, :request_deleted, :boolean, :default => false
  end
end
