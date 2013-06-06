# coding: UTF-8

class AddGridColumnInBirkmanDetail < ActiveRecord::Migration
  def self.up
      add_column :job_seeker_birkman_details,:grid_work_environment_x,:integer
      add_column :job_seeker_birkman_details,:grid_work_environment_y,:integer
      add_column :job_seeker_birkman_details,:grid_work_role_x,:integer
      add_column :job_seeker_birkman_details,:grid_work_role_y,:integer
      
  end

  def self.down
      remove_column :job_seeker_birkman_details,:grid_work_environment_x
      remove_column :job_seeker_birkman_details,:grid_work_environment_y
      remove_column :job_seeker_birkman_details,:grid_work_role_x
      remove_column :job_seeker_birkman_details,:grid_work_role_y
  end
end
