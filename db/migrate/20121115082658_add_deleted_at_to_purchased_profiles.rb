class AddDeletedAtToPurchasedProfiles < ActiveRecord::Migration
  def change
    add_column :purchased_profiles, :deleted_at, :time
  end
end
