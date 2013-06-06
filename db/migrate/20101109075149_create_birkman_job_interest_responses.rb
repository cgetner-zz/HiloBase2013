# coding: UTF-8

class CreateBirkmanJobInterestResponses < ActiveRecord::Migration
  def self.up
    create_table :birkman_job_interest_responses, :options => "ENGINE=InnoDB" do |t|
      t.integer :birkman_job_interest_id
      t.integer :job_seeker_id
      t.string :choice, :limit=>15
      t.timestamps
    end
  end

  def self.down
    drop_table :birkman_job_interest_responses
  end
end
