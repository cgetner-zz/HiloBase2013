class AddMissingColumnsIntoGuestJobSeekers < ActiveRecord::Migration
  def up
    add_column :guest_job_seekers, :test_complete, :boolean
    add_column :guest_job_seekers, :responded_birkman_set_number, :integer
    add_column :guest_job_seekers, :us_citizen, :integer, :limit => 3
    add_column :guest_job_seekers, :pass_through, :integer, :limit => 3
  end

  def down
    remove_column :guest_job_seekers, :test_complete
    remove_column :guest_job_seekers, :responded_birkman_set_number
    remove_column :guest_job_seekers, :us_citizen
    remove_column :guest_job_seekers, :pass_through
  end
end
