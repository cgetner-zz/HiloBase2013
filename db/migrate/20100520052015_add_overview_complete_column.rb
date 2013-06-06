# coding: UTF-8

class AddOverviewCompleteColumn < ActiveRecord::Migration
  def self.up
      add_column :jobs,:overview_complete,:boolean,:default=>false
      add_column :jobs,:administration_complete,:boolean,:default=>false
  end

  def self.down
      remove_column :jobs,:overview_complete
      remove_column :jobs,:administration_complete
  end
end
