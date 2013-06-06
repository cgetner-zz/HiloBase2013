# coding: UTF-8

class CreateJobSeekerEducationLevels < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_education_levels do |t|
      t.integer :job_seeker_id
      t.integer :education_level_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_education_levels
  end
end
