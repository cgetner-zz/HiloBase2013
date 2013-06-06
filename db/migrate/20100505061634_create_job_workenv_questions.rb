# coding: UTF-8

class CreateJobWorkenvQuestions < ActiveRecord::Migration
  def self.up
    create_table :job_workenv_questions, :options => "ENGINE=InnoDB"  do |t|
      t.integer :workenv_question_id
      t.integer :job_id
      t.integer :score
      t.timestamps
    end
  end

  def self.down
    drop_table :job_workenv_questions
  end
end
