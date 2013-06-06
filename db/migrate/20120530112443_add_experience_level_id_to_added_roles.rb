class AddExperienceLevelIdToAddedRoles < ActiveRecord::Migration
  def change
    add_column :added_roles, :experience_level_id, :integer
  end
end
