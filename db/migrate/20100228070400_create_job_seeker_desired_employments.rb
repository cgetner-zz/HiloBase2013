# coding: UTF-8

class CreateJobSeekerDesiredEmployments < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_desired_employments, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_seeker_id
      t.integer :desired_employment_id
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_desired_employments
  end
end
