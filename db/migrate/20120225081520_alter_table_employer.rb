# coding: UTF-8

class AlterTableEmployer < ActiveRecord::Migration
  def self.up
    change_column :employers, :emp_admin,:integer, :default=> nil
  end

  def self.down
    add_column :employers, :emp_admin,:string, :default=> nil
  end
end
