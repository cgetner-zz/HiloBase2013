class AddEmployerIdToCompanyGroups < ActiveRecord::Migration
  def change
    add_column :company_groups, :employer_id, :integer
  end
end
