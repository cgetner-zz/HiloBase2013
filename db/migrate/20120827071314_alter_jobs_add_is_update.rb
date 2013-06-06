class AlterJobsAddIsUpdate < ActiveRecord::Migration
  def up
    add_column :jobs, :is_updated, :boolean, :default => 0
  end

  def down
    remove_column :jobs, :is_updated
  end
end
