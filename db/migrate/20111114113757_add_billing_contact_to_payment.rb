# coding: UTF-8

class AddBillingContactToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :billing_contact, :string
  end

  def self.down
    remove_column :payments, :billing_contact
  end
end
