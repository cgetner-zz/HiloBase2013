# coding: UTF-8

class AddPairingCompleteColumnsToJobs < ActiveRecord::Migration
  def self.up
      add_column :jobs,:basic_complete,:boolean,:default=>false
      add_column :jobs,:credential_complete,:boolean,:default=>false
      add_column :jobs,:personality_work_complete,:boolean,:default=>false
      add_column :jobs,:personality_role_complete,:boolean,:default=>false
  end

  def self.down
      remove_column :jobs,:basic_complete
      remove_column :jobs,:credential_complete
      remove_column :jobs,:personality_work_complete
      remove_column :jobs,:personality_role_complete
  end
end
