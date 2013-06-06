class AddCompanyIdToPurchasedProfiles < ActiveRecord::Migration
  def change
    add_column :purchased_profiles, :company_id, :integer
  end
end
