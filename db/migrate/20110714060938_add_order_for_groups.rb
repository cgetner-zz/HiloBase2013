# coding: UTF-8

class AddOrderForGroups < ActiveRecord::Migration
  def self.up
      add_column :company_groups, :sort_index, :integer
      add_column :jobs, :sort_index, :integer
      
      CompanyGroup.find(:all).each do |cg|
        cg.sort_index = cg.id
        cg.save(:validate => false)
      end
      
      
      Job.with_deleted.find(:all).each do |j|
        j.sort_index = j.id
        j.save(:validate => false)
      end
      
  end

  def self.down
      remove_column :company_groups, :sort_index
      remove_column :jobs, :sort_index
  end
end
