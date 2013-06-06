class AddColToUniActivated < ActiveRecord::Migration
  def change
    add_column :universities, :activated, :boolean, :default => true
  end
end