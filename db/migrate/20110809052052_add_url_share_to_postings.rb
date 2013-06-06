# coding: UTF-8

class AddUrlShareToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings,:url_share,:boolean
  end

  def self.down
     remove_column :postings, :url_share
  end
end
