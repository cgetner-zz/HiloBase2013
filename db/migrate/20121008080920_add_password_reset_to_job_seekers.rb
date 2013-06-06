class AddPasswordResetToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :password_reset, :boolean, :default=>true
  end
end
