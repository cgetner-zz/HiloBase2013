class AddMonthlyRenewTimeToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :monthly_renew_time, :datetime
  end
end
