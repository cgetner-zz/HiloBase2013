class AddDeletedToCareerSeekerSavedSearches < ActiveRecord::Migration
  def change
    add_column :career_seeker_saved_searches, :deleted, :boolean, :default=>false
  end
end
