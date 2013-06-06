# coding: UTF-8

class AddCompanyNameInPayment < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE payments ADD COLUMN company_name varchar(255) AFTER employer_id"
  end

  def self.down
     remove_column :company_name
  end
end
