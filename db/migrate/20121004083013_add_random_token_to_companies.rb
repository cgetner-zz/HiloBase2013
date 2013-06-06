class AddRandomTokenToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :random_token, :string
  end
end
