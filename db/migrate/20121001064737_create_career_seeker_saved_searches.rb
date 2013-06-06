class CreateCareerSeekerSavedSearches < ActiveRecord::Migration
  def change
    create_table :career_seeker_saved_searches do |t|
      t.integer :job_seeker_id
      t.string :keyword

      t.timestamps
    end
  end
end
