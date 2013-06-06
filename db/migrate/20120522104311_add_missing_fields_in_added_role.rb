class AddMissingFieldsInAddedRole < ActiveRecord::Migration
  def up
    #add_column :added_roles, :education_level, :string
    add_column :added_roles, :experience_level, :string
  end

  def down
    remove_column :added_roles, :education_level
    remove_column :added_roles, :experience_level
  end
end
