# coding: UTF-8

class AddEducationIdAndSkillIdToJobSeekerProficiencies < ActiveRecord::Migration
  def self.up
    add_column :job_seeker_proficiencies, :education_id, :integer, :default => nil
    add_column :job_seeker_proficiencies, :skill_id, :integer, :default => nil

  end
  def self.down
    remove_column :job_seeker_proficiencies, :education_id
    remove_column :job_seeker_proficiencies, :skill_id
  end
end
