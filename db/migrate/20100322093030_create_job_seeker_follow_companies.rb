# coding: UTF-8

class CreateJobSeekerFollowCompanies < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_follow_companies, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_seeker_id
      t.integer :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_follow_companies
  end
end
