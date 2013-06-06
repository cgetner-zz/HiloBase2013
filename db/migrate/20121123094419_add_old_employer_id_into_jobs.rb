class AddOldEmployerIdIntoJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :old_employer_id, :integer
  end

  def self.down
    remove_column :jobs, :old_employer_id
  end
end
