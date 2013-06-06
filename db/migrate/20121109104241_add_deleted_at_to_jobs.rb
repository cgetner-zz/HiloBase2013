class AddDeletedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :deleted_at, :time
  end
end
