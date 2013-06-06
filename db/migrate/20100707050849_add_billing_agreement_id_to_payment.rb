# coding: UTF-8

class AddBillingAgreementIdToPayment < ActiveRecord::Migration
  def self.up
      add_column :payments,:id_billing_agreement,:string
  end

  def self.down
      remove_column :payments,:id_billing_agreement
  end
end
