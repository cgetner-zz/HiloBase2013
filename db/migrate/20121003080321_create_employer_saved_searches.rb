class CreateEmployerSavedSearches < ActiveRecord::Migration
  def change
    create_table :employer_saved_searches do |t|
      t.integer :employer_id
      t.string :keyword
      t.string :name
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end
end
