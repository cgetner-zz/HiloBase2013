class AddCoverNoteColumnToJobStatusesTable < ActiveRecord::Migration
  def self.up
      add_column :job_statuses, :cover_note, :text, :limit => 550
  end

  def self.down
      remove_column :job_statuses, :cover_note
  end
end
