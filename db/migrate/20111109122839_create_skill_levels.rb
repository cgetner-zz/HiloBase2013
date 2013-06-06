# coding: UTF-8

class CreateSkillLevels < ActiveRecord::Migration
  def self.up
    create_table :skill_levels do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :skill_levels
  end
end
