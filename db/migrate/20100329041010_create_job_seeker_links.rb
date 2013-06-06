# coding: UTF-8

class CreateJobSeekerLinks < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_links, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_seeker_id
      t.text :url
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_links
  end
end
