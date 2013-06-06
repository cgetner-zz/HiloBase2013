# coding: UTF-8

class AddJobCriteriaColumnsToJobs < ActiveRecord::Migration
  
  def self.up
      add_column :jobs,:minimum_compensation_amount,:float,:default=>0
      add_column :jobs,:desired_paid_offs,:integer,:default=>0
      add_column :jobs,:desired_commute_radius,:integer,:default=>0
      add_column :jobs,:work_exp_value,:integer,:default=>0
  end

  def self.down
      remove_column :jobs,:minimum_compensation_amount
      remove_column :jobs,:desired_paid_offs
      remove_column :jobs,:desired_commute_radius
      remove_column :jobs,:work_exp_value
  end
end


