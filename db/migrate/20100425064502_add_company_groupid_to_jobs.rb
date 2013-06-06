# coding: UTF-8

class AddCompanyGroupidToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs,:company_group_id,:integer
    add_column :jobs,:active,:boolean,:default=> false
  end

  def self.down
    remove_column :jobs,:company_group_id
    remove_column :jobs,:active
  end
end
