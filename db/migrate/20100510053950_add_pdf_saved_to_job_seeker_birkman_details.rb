# coding: UTF-8

class AddPdfSavedToJobSeekerBirkmanDetails < ActiveRecord::Migration
  def self.up
      add_column :job_seeker_birkman_details,:pdf_saved,:boolean,:default=>false
  end

  def self.down
    remove_column :job_seeker_birkman_details,:pdf_saved
  end
end
