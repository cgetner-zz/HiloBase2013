# coding: UTF-8

class AddOriginationToPromotionalCodes < ActiveRecord::Migration
  def self.up
      add_column :promotional_codes,:origination,:string
  end

  def self.down
    remove_column :promotional_codes,:origination
  end
end
