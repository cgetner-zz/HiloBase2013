class AddCompanyIdToReferralFeesTable < ActiveRecord::Migration
  def change
    add_column :referral_fees, :company_id, :integer
  end
end
