# coding: UTF-8

class AddWorkexpToJobseeker < ActiveRecord::Migration
  def self.up
      add_column :job_seekers,:work_exp_value,:integer,:default=>0
  end

  def self.down
    remove_column :job_seekers,:work_exp_value
  end
end
