# coding: UTF-8

class CreateEmployerViewJobSeekers < ActiveRecord::Migration
  def self.up
    create_table :employer_view_job_seekers, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_seeker_id
      t.integer :employer_id
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :employer_view_job_seekers
  end
end
