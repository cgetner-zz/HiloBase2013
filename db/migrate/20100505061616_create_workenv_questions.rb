# coding: UTF-8

class CreateWorkenvQuestions < ActiveRecord::Migration
  def self.up
    create_table :workenv_questions, :options => "ENGINE=InnoDB"  do |t|
      t.string :low_side_statement
      t.string :high_side_statement
      t.string :scoring_direction,:limit=>5    #POS OR NEG
      t.integer :order
      t.string :apply_on,:limit=>5 # X or Y

      t.timestamps
    end
  end

  def self.down
    drop_table :workenv_questions
  end
end
