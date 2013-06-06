class AddNoResultFlagToGuestJobSeekers < ActiveRecord::Migration
  def change
    add_column :guest_job_seekers, :no_result_flag, :boolean, :default => false
  end
end
