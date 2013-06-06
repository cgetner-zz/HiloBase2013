# coding: UTF-8

class UpdateWorkEnvQuestions < ActiveRecord::Migration
  def self.up
    add_column :workenv_questions, :description_left, :text
    add_column :workenv_questions, :description_right, :text
  end

  def self.down
    remove_column :workenv_questions, :description_left
    remove_column :workenv_questions, :description_right
  end
end
