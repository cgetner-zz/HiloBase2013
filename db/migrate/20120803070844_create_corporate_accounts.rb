class CreateCorporateAccounts < ActiveRecord::Migration
  def change
    create_table :corporate_accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :company_name
      t.integer :contact

      t.timestamps
    end
  end
end
