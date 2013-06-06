class CreateGuestJobSeekers < ActiveRecord::Migration
  def change
    create_table :guest_job_seekers do |t|
      t.string :email
      t.string :unique_identifier
      t.string :birkman_user_id
      t.integer :responded_birkman_question_id
      t.timestamps
    end
  end
end
