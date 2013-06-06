class PopulateAccountType < ActiveRecord::Migration
  def up
    AccountType.create(:account_type=>"Corporate Root")
    AccountType.create(:account_type=>"Corporate Sub")
    AccountType.create(:account_type=>"Freelancer")
  end

  def down
    AccountType.delete_all("account_type = 'Corporate Root' OR account_type = 'Corporate Sub' OR account_type = 'Freelancer'")
  end
end
