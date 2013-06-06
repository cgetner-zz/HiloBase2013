class AddDeletedAtToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :deleted_at, :time
  end
end
