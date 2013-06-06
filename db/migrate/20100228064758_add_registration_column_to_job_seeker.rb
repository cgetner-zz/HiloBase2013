# coding: UTF-8

class AddRegistrationColumnToJobSeeker < ActiveRecord::Migration
  def self.up
      add_column :job_seekers,:completed_registration_step,:integer
      add_column :job_seekers,:minimum_compensation_amount,:float,:default=>0
      add_column :job_seekers,:desired_paid_offs,:integer,:default=>0
      add_column :job_seekers,:desired_commute_radius,:integer,:default=>0
  end

  def self.down
      remove_column :job_seekers,:completed_registration_step
      remove_column :job_seekers,:minimum_compensation_amount
      remove_column :job_seekers,:desired_paid_offs
      remove_column :job_seekers,:desired_commute_radius
  end
end
