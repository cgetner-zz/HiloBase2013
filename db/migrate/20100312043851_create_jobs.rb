# coding: UTF-8

class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.string :code
      t.string :position
      t.integer :job_location_id
      t.datetime :expire_at
      t.integer :employer_id
      t.integer :marks
      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
