# coding: UTF-8

class CreateBirkmanQuestions < ActiveRecord::Migration
  def self.up
    create_table :birkman_questions do |t|
      t.string :question
      t.integer :set_number

      t.timestamps
    end
  end

  def self.down
    drop_table :birkman_questions
  end
end
