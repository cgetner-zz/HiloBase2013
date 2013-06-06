# coding: UTF-8

class AddOnlinePresenceToJobSekkerTable < ActiveRecord::Migration
  def self.up
	add_column :job_seekers, :website_one,:string, :default=> nil
	add_column :job_seekers, :website_two,:string, :default=> nil
	add_column :job_seekers, :website_three,:string, :default=> nil
	add_column :job_seekers, :website_title_one,:string, :default=> nil
	add_column :job_seekers, :website_title_two,:string, :default=> nil
	add_column :job_seekers, :website_title_three,:string, :default=> nil
  end

  def self.down
	remove_column :job_seekers, :website_one
	remove_column :job_seekers, :website_two
	remove_column :job_seekers, :website_three
	remove_column :job_seekers, :website_title_one
	remove_column :job_seekers, :website_title_two
	remove_column :job_seekers, :website_title_three
  end
end
