# coding: UTF-8

class AddColumnsToWorkenvQuestions < ActiveRecord::Migration
  def self.up
	add_column :workenv_questions, :question, :string
	add_column :workenv_questions, :xscoring, :string, :limit=>5
	add_column :workenv_questions, :yscoring, :string, :limit=>5
	
	remove_column :workenv_questions, :low_side_statement
	remove_column :workenv_questions, :high_side_statement
	remove_column :workenv_questions, :scoring_direction
	remove_column :workenv_questions, :apply_on
  end

  def self.down
	remove_column :workenv_questions, :question
	remove_column :workenv_questions, :xscoring
	remove_column :workenv_questions, :yscoring
	
	add_column :workenv_questions, :low_side_statement, :string
	add_column :workenv_questions, :high_side_statement, :string
	add_column :workenv_questions, :scoring_direction, :string, :limit=>5
	add_column :workenv_questions, :apply_on, :string, :limit=>5
  end
end
