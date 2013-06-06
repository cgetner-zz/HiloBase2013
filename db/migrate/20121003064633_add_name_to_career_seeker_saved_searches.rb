class AddNameToCareerSeekerSavedSearches < ActiveRecord::Migration
  def change
    add_column :career_seeker_saved_searches, :name, :string
  end
end
