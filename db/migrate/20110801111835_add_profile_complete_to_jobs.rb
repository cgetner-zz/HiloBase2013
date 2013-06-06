# coding: UTF-8

class AddProfileCompleteToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs,:profile_complete,:boolean,:default=>false
  end

  def self.down
  end
end
