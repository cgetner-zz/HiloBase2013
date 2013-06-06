# coding: UTF-8

class AddCreatedbyInCompCompanyIdInJob < ActiveRecord::Migration
  def self.up
      add_column :companies,:created_by,:integer
      add_column :jobs,:company_id,:integer
  end

  def self.down
      remove_column :companies,:created_by
      remove_column :jobs,:company_id
  end
end
