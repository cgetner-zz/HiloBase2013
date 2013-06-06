# coding: UTF-8

class CreateBirkmanQuestionResponses < ActiveRecord::Migration
  def self.up
    create_table :birkman_question_responses do |t|
      t.integer :job_seeker_id
      t.integer :birkman_question_id
      t.boolean :response, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :birkman_question_responses
  end
end
