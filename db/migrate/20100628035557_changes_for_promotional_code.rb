# coding: UTF-8

class ChangesForPromotionalCode < ActiveRecord::Migration
  def self.up
      remove_column :promotional_codes,:discount_amount_usd
      
      add_column :promotional_codes,:amount,:float
      add_column :promotional_codes,:employer_id,:integer
      add_column :promotional_codes,:given,:boolean,:default=>false
      add_column :promotional_codes,:consumed_amount,:float,:default=> 0
      
      add_column :payments,:paypal_amount,:float
      add_column :payments,:promotional_code_amount,:float
  end

  def self.down
      add_column :promotional_codes,:discount_amount_usd,:float
      
      remove_column :promotional_codes,:amount
      remove_column :promotional_codes,:employer_id
      remove_column :promotional_codes,:given
      remove_column :promotional_codes,:consumed_amount
      
      remove_column :payments,:paypal_amount
      remove_column :payments,:promotional_code_amount
  end
end
