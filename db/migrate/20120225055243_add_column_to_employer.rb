# coding: UTF-8

class AddColumnToEmployer < ActiveRecord::Migration
  def self.up
    add_column :employers, :emp_admin,:string, :default=> nil
  end

  def self.down
    remove_column :employers, :emp_admin
  end
end
