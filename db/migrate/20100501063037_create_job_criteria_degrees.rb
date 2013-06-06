# coding: UTF-8

class CreateJobCriteriaDegrees < ActiveRecord::Migration
  def self.up
    create_table :job_criteria_degrees, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_id
      t.integer :degree_id
      t.timestamps
    end
  end

  def self.down
    drop_table :job_criteria_degrees
  end
end
