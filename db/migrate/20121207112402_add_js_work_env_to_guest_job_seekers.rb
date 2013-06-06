class AddJsWorkEnvToGuestJobSeekers < ActiveRecord::Migration
  def change
    add_column :guest_job_seekers, :js_work_env, :string, :default => nil
  end
end
