# coding: UTF-8

class CreateJobCriteriaDesiredEmployments < ActiveRecord::Migration
  def self.up
    create_table :job_criteria_desired_employments, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_id
      t.integer :desired_employment_id
      t.timestamps
      t.timestamps
    end
  end

  def self.down
    drop_table :job_criteria_desired_employments
  end
end
