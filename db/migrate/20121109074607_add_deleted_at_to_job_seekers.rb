class AddDeletedAtToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :deleted_at, :time
  end
end
