# coding: UTF-8

class CreateJobSeekerLanguages < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_languages, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_seeker_id
      t.integer :language_id
      t.string :proficiency_val, :limit   =>10
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_languages
  end
end
