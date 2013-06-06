class AddColumnsIntoGuestJobSeekers < ActiveRecord::Migration
  def up
    add_column :guest_job_seekers, :test_submitted, :boolean
    add_column :guest_job_seekers, :grid_work_environment_x, :integer, :limit => 3
    add_column :guest_job_seekers, :grid_work_environment_y, :integer, :limit => 3
    add_column :guest_job_seekers, :grid_work_role_x, :integer, :limit => 3
    add_column :guest_job_seekers, :grid_work_role_y, :integer, :limit => 3
  end

  def down
    remove_column :guest_job_seekers, :test_submitted
    remove_column :guest_job_seekers, :grid_work_environment_x
    remove_column :guest_job_seekers, :grid_work_environment_y
    remove_column :guest_job_seekers, :grid_work_role_x
    remove_column :guest_job_seekers, :grid_work_role_y
  end
end
