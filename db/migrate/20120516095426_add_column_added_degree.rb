class AddColumnAddedDegree < ActiveRecord::Migration
  def up
    add_column :added_degrees, :degree_status, :string
  end

  def down
    remove_column :added_degrees, :degree_status
  end
end
