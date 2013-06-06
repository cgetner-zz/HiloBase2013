class AddInternalToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :internal, :boolean, :default=>false
  end
end
