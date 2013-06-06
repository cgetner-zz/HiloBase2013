# coding: UTF-8

class AddPaymentColumns < ActiveRecord::Migration
  def self.up
      add_column :payments,:job_id,:integer
      add_column :payments,:card_number,:string
  end

  def self.down
      remove_column :payments,:job_id
      remove_column :payments,:card_number
  end
end
