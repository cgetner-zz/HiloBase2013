class AddCompanyIdToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :company_id, :integer
  end
end
