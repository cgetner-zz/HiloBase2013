# coding: UTF-8

class AddPassThroughInBirkmanDetails < ActiveRecord::Migration
  
  def self.up
      add_column :job_seeker_birkman_details, :pass_through, :boolean, :default => false
      
      add_column :job_seeker_birkman_details, :pass_first_name, :string
      add_column :job_seeker_birkman_details, :pass_last_name, :string
      add_column :job_seeker_birkman_details, :pass_email, :string
      add_column :job_seeker_birkman_details, :pass_birkman_code, :string
  end

  def self.down
      remove_column :job_seeker_birkman_details, :pass_through
      
      remove_column :job_seeker_birkman_details, :pass_first_name
      remove_column :job_seeker_birkman_details, :pass_last_name
      remove_column :job_seeker_birkman_details, :pass_email
      remove_column :job_seeker_birkman_details, :pass_birkman_code
  end

end
