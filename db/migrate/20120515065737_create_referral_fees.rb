class CreateReferralFees < ActiveRecord::Migration
  def up
    create_table :referral_fees do |t|
      t.integer :job_seeker_id
      t.integer :job_id
      t.integer :share_platform_id
      t.boolean :credit_flag, :default => false
      t.boolean :discount_flag, :default => false
      t.boolean :referral_fee_flag, :default => false
      t.timestamps
    end
  end

  def down
    drop_table :referral_fees
  end
end
