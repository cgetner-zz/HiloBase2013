class DeleteColumnsFromAddedRoles < ActiveRecord::Migration
  def up
    #remove_column :added_roles, :education_level
    remove_column :added_roles, :experience_level
  end
end
