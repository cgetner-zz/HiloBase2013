# coding: UTF-8

class ChangesToJobTableToUnlockCompanyName < ActiveRecord::Migration
  def self.up
	add_column :jobs, :hiring_company, :boolean, :default => true
	add_column :jobs, :hiring_company_name, :string, :default => nil
	add_column :jobs, :website_one,:string, :default=> nil
	add_column :jobs, :website_two,:string, :default=> nil
	add_column :jobs, :website_three,:string, :default=> nil
	add_column :jobs, :website_title_one,:string, :default=> nil
	add_column :jobs, :website_title_two,:string, :default=> nil
	add_column :jobs, :website_title_three,:string, :default=> nil
  end

  def self.down
	remove_column :jobs, :hiring_company
	remove_column :jobs, :hiring_company_name
	remove_column :jobs, :website_one
	remove_column :jobs, :website_two
	remove_column :jobs, :website_three
	remove_column :jobs, :website_title_one
	remove_column :jobs, :website_title_two
	remove_column :jobs, :website_title_three
  end
end
