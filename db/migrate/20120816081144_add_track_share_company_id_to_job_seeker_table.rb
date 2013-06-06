class AddTrackShareCompanyIdToJobSeekerTable < ActiveRecord::Migration
  def change
    add_column :job_seekers, :track_shared_company_id, :string, :default => nil
  end
end
