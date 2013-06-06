# coding: UTF-8

class AddProfileIdColumnInPayment < ActiveRecord::Migration
  def self.up
      add_column :payments, :profile_id, :integer
  end

  def self.down
      remove_column :payments, :profile_id
  end
end
