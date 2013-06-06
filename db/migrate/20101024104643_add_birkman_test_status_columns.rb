# coding: UTF-8

class AddBirkmanTestStatusColumns < ActiveRecord::Migration
  def self.up
           add_column :job_seeker_birkman_details, :responded_birkman_question_id, :integer
           add_column :job_seeker_birkman_details, :responded_birkman_set_number, :integer
           add_column :job_seeker_birkman_details, :us_citizen, :boolean, :default => false
  end

  def self.down
           remove_column :job_seeker_birkman_details, :responded_birkman_question_id
           remove_column :job_seeker_birkman_details, :responded_birkman_set_number
           remove_column :job_seeker_birkman_details, :us_citizen
  end
end
