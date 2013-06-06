# coding: UTF-8

class CreateJobCriteriaProficiencies < ActiveRecord::Migration
  def self.up
    create_table :job_criteria_proficiencies, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_id
      t.integer :proficiency_id
      t.string :proficiency_val, :limit   =>10
      t.timestamps
      t.timestamps
    end
  end

  def self.down
    drop_table :job_criteria_proficiencies
  end
end
