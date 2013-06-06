# coding: UTF-8

class CreateJobSeekerBirkmanDetails < ActiveRecord::Migration
  def self.up
    create_table :job_seeker_birkman_details, :options => "ENGINE=InnoDB"  do |t|
      t.integer :job_seeker_id
      t.string :unique_identifier
      t.string :questionnaire_url
      t.string :birkman_user_id
      t.string :status
      t.text :last_log
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seeker_birkman_details
  end
end
