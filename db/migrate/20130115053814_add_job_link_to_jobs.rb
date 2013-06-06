class AddJobLinkToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :job_link, :string
  end
end
