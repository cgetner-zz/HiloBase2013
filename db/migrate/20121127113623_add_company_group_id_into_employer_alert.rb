class AddCompanyGroupIdIntoEmployerAlert < ActiveRecord::Migration
  def self.up
	add_column :employer_alerts, :company_group_id, :integer
  end

  def self.down
	remove_column :employer_alerts, :company_group_id
  end
end
