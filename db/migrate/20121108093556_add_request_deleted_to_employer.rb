class AddRequestDeletedToEmployer < ActiveRecord::Migration
  def change
    add_column :employers, :request_deleted, :boolean, :default => false
  end
end
