class CreateAccountTypes < ActiveRecord::Migration
  def change
    create_table :account_types do |t|
      t.string :account_type

      t.timestamps
    end
  end
end
