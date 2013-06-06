class AddCreditAmountToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :credit_amount, :float
  end
end
