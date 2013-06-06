class AddFlagsToCompanyPostingTable < ActiveRecord::Migration
  def up
    add_column :company_postings, :facebook_flag, :boolean, :default => false
    add_column :company_postings, :linkedin_flag, :boolean, :default => false
    add_column :company_postings, :twitter_flag, :boolean, :default => false
  end

  def down
    remove_column :company_postings, :facebook_flag
    remove_column :company_postings, :linkedin_flag
    remove_column :company_postings, :twitter_flag
  end
end
