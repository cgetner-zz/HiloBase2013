class AddGraphicalContentFlagToCompanyTable < ActiveRecord::Migration
  def up
    add_column :companies, :graphical_content, :boolean, :default => true
  end

  def down
    remove_column :companies, :graphical_content
  end
end
