class AddSpendingLimitCrossedToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :spending_limit_crossed_flag, :boolean, :default => false
  end
end
