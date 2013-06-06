# coding: UTF-8

class AddCardTypeToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :card_type, :string, :default=>nil
  end

  def self.down
    remove_column :payments, :card_type
  end
end
