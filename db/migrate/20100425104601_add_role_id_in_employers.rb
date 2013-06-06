# coding: UTF-8

class AddRoleIdInEmployers < ActiveRecord::Migration
  def self.up
      add_column :employers,:role_id,:integer
  end

  def self.down
    remove_column :employers,:role_id
  end
end
