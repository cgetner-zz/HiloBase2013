class AddAccessLevelIntoAdministrators < ActiveRecord::Migration
  def up
    add_column :administrators, :access_level_id, :integer
  end

  def down
    remove_column :administrators, :access_level_id
  end
end
