# coding: UTF-8

class AddWorkRoleScoreForJobs < ActiveRecord::Migration
  
  def self.up
      add_column :jobs,:grid_work_environment_x,:integer
      add_column :jobs,:grid_work_environment_y,:integer
      add_column :jobs,:grid_work_role_x,:integer
      add_column :jobs,:grid_work_role_y,:integer
  end

  def self.down
      remove_column :jobs,:grid_work_environment_x
      remove_column :jobs,:grid_work_environment_y
      remove_column :jobs,:grid_work_role_x
      remove_column :jobs,:grid_work_role_y
  end

end
