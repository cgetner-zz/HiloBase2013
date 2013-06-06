# coding: UTF-8

class AddColumnsToComapnies < ActiveRecord::Migration
  def self.up
    add_column :companies,:street_one,:string
    add_column :companies,:street_two,:string
    add_column :companies,:city,:string
    add_column :companies,:zip,:string
    add_column :companies,:phone,:string
    add_column :companies,:fax,:string
    add_column :companies,:founded_in,:string
    add_column :companies,:employee_strength,:integer
    add_column :companies,:website,:string
    add_column :companies,:facebook_link,:string
    add_column :companies,:twitter_link,:string
    add_column :companies,:other_link_one,:string
    add_column :companies,:other_link_two,:string
    add_column :companies,:owner_ship_type_id,:integer
    add_column :companies,:ticker_value,:string

    
  end

  def self.down
    remove_column :companies,:street_one
    remove_column :companies,:street_two
    remove_column :companies,:city
    remove_column :companies,:zip
    remove_column :companies,:phone
    remove_column :companies,:fax
    remove_column :companies,:founded_in
    remove_column :companies,:employee_strength
    remove_column :companies,:website
    remove_column :companies,:facebook_link
    remove_column :companies,:twitter_link
    remove_column :companies,:other_link_one
    remove_column :companies,:other_link_two
    remove_column :companies,:owner_ship_type_id
    remove_column :companies,:ticker_value

  end
end
