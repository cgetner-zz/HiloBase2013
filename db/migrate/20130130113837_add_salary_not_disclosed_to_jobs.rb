class AddSalaryNotDisclosedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :salary_not_disclosed, :boolean, :default=>false
  end
end
