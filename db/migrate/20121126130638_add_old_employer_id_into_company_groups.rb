class AddOldEmployerIdIntoCompanyGroups < ActiveRecord::Migration
  def self.up
	add_column :company_groups, :old_employer_id, :integer
  end

  def self.down
	remove_column :company_groups, :old_employer_id
  end
end
