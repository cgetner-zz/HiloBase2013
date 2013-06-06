class ModificationsToReferralFees < ActiveRecord::Migration
  def up
    remove_column :referral_fees, :discount_flag
    remove_column :referral_fees, :credit_flag
    add_column :referral_fees, :discount_amount, :float
    add_column :referral_fees, :credit_amount, :float
  end
end
