class AddRequiredFlagToAddedDegrees < ActiveRecord::Migration
  def change
    add_column :added_degrees, :required_flag, :boolean
  end
end
