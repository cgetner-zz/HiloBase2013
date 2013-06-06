class AddRequiredColumnsIntoGuestJobSeekers < ActiveRecord::Migration
  def up
	add_column :guest_job_seekers, :pdf_saved, :boolean, :default => 0
	remove_column :guest_job_seekers, :pass_through
  end

  def down
	remove_column :guest_job_seekers, :pdf_saved
	add_column :guest_job_seekers, :pass_through
  end
end
