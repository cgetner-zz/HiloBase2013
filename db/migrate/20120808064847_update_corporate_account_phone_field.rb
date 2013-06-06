class UpdateCorporateAccountPhoneField < ActiveRecord::Migration
  def up
    change_column :corporate_accounts, :contact, :integer, :limit => 8
  end

  def down
    change_column :corporate_accounts, :contact, :integer
  end
end
