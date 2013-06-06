# coding: UTF-8

class AddDeletedColumnInCompanygrpAndJobs < ActiveRecord::Migration
  def self.up
      add_column :company_groups,:deleted,:boolean,:default => false
      add_column :jobs,:deleted,:boolean,:default => false
  end

  def self.down
      remove_column :company_groups,:deleted
      remove_column :jobs,:deleted
  end
end
