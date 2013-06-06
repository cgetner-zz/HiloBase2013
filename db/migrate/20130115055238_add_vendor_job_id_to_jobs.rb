class AddVendorJobIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :vendor_job_id, :string
  end
end
