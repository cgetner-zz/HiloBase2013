# coding: UTF-8

class RenameColumnAdministrationCompleteToDetailedPreviewedInJobsTable < ActiveRecord::Migration
  def up
	rename_column :jobs, :administration_complete, :detail_preview
  end

  def down
	rename_column :jobs, :detail_preview, :administration_complete
  end
end
