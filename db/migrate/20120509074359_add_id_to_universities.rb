class AddIdToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :id, :primary_key
  end
end
