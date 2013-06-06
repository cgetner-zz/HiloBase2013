class AddEducationLevelIdToAddedRoles < ActiveRecord::Migration
  def change
    add_column :added_roles, :education_level_id, :integer
  end
end
