# coding: UTF-8

class CreateRoleQuestions < ActiveRecord::Migration
  def self.up
    create_table :role_questions, :options => "ENGINE=InnoDB"  do |t|
      t.string :question
      t.string :xscoring,:limit=>5 # POS or NEG or NO
      t.string :yscoring,:limit=>5 # POS or NEG or NO
      t.integer :order
      t.timestamps
    end
  end

  def self.down
    drop_table :role_questions
  end
end
