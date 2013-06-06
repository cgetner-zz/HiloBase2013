# coding: UTF-8

class CountColumnsInPosting < ActiveRecord::Migration
  def self.up
    add_column :postings,:hilo_count,:integer,:default=>0
    add_column :postings,:facebook_count,:integer,:default=>0
    add_column :postings,:twitter_count,:integer,:default=>0
    add_column :postings,:linkedin_count,:integer,:default=>0
    add_column :postings,:url_count,:integer,:default=>0    
  end

  def self.down
    remove_column :postings, :hilo_count
    remove_column :postings, :facebook_count
    remove_column :postings, :twitter_count
    remove_column :postings, :linkedin_count
    remove_column :postings, :url_count
  end
end
