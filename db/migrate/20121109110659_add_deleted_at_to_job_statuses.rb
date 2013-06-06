class AddDeletedAtToJobStatuses < ActiveRecord::Migration
  def change
    add_column :job_statuses, :deleted_at, :time
  end
end
