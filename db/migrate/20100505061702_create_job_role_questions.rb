# coding: UTF-8

class CreateJobRoleQuestions < ActiveRecord::Migration
  def self.up
    create_table :job_role_questions , :options => "ENGINE=InnoDB" do |t|
      t.integer :role_question_id
      t.integer :job_id
      t.integer :score
      t.timestamps
    end
  end

  def self.down
    drop_table :job_role_questions
  end
end
