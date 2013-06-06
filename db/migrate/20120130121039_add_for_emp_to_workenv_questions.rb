# coding: UTF-8

class AddForEmpToWorkenvQuestions < ActiveRecord::Migration
  def self.up
    add_column :workenv_questions, :for_emp, :boolean
  end

  def self.down
    remove_column :workenv_questions, :for_emp
  end
end
