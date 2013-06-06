class AddFirstActiveToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :first_active, :datetime
  end
end
