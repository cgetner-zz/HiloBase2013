class AddDeletedToJobSeeker < ActiveRecord::Migration
  def change
    add_column :job_seekers, :deleted, :boolean, :default => false
  end
end
