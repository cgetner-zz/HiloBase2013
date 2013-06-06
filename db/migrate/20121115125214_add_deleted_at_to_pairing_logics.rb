class AddDeletedAtToPairingLogics < ActiveRecord::Migration
  def change
    add_column :pairing_logics, :deleted_at, :time
  end
end
