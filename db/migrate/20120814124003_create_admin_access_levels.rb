class CreateAdminAccessLevels < ActiveRecord::Migration
  def change
    create_table :admin_access_levels do |t|
      t.integer :administrator_id
      t.integer :access_level_id
      t.timestamps
    end
  end
end
