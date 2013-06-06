class AddIcsTypeIdToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :ics_type_id, :integer, :default => 4
  end
end
