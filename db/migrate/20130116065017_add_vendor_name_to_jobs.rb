class AddVendorNameToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :vendor_name, :string
  end
end
