class CreateSpendingLimits < ActiveRecord::Migration
  def up
    create_table :spending_limits do |t|
      t.integer :employer_id
      t.float :spend_limit
      t.integer :setter_id
      t.float :available_balance
    end
  end

  def down
    drop_table :spending_limits
  end
end
