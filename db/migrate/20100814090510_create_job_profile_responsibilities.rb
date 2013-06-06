# coding: UTF-8

class CreateJobProfileResponsibilities < ActiveRecord::Migration
  
  def self.up
    create_table :job_profile_responsibilities, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_id
      t.integer :profile_responsibility_id
      t.timestamps
    end
  end

  def self.down
    drop_table :job_profile_responsibilities
  end

end
