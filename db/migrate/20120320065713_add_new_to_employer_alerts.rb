# coding: UTF-8

class AddNewToEmployerAlerts < ActiveRecord::Migration
  def self.up
    add_column :employer_alerts, :new, :boolean, :default => true
  end

  def self.down
    remove_column :employer_alerts
  end
end
