class AddSpendingFlagAndMonthlyRenewFlagToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :spending_flag, :boolean, :default => false
    add_column :employers, :monthly_renew_flag, :boolean, :default => false
  end
end
