# coding: UTF-8

class UpdateNameEducationLevels < ActiveRecord::Migration
  def self.up
    execute("UPDATE education_levels SET name ='Undergraduate degree' WHERE name ='Undergraduated degree'")
  end

  def self.down
  end
end
