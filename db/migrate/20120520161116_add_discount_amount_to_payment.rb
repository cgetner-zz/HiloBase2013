class AddDiscountAmountToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :discount_amount, :float
  end
end
