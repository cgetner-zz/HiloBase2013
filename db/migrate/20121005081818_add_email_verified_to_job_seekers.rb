class AddEmailVerifiedToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :email_verified, :boolean, :default=>true
  end
end
