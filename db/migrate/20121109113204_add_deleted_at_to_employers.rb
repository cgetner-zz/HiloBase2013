class AddDeletedAtToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :deleted_at, :time
  end
end
