# coding: UTF-8

class AddEmployerIdToPayments < ActiveRecord::Migration
  def self.up
      add_column :payments,:employer_id,:integer
  end

  def self.down
      remove_column :payments,:employer_id
  end
end
