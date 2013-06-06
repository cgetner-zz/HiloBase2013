# coding: UTF-8

class CreateJobCriteriaLanguages < ActiveRecord::Migration
  def self.up
    create_table :job_criteria_languages, :options => "ENGINE=InnoDB"  do |t|
      t.integer :job_id
      t.integer :language_id
      t.string :proficiency_val, :limit =>10
      t.boolean :required_flag, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :job_criteria_languages
  end
end
