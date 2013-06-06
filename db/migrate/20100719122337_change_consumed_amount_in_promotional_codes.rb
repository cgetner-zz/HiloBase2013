# coding: UTF-8

class ChangeConsumedAmountInPromotionalCodes < ActiveRecord::Migration
  def self.up
      execute("ALTER TABLE promotional_codes MODIFY consumed_amount FLOAT NOT NULL DEFAULT '0'")
  end

  def self.down
  end
end
