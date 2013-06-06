class CreateGuestJobSeekerWorkenvQuestions < ActiveRecord::Migration
  def change
    create_table :guest_job_seeker_workenv_questions do |t|
      t.integer :guest_job_seeker_id
      t.integer :workenv_question_id
      t.integer :score
      t.timestamps
    end
  end
end
