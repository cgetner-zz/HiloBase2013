# coding: UTF-8

class CreateJobSeekerDegrees < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_degrees, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_seeker_id
      t.integer :degree_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_degrees
  end
end
