class AddAlertMethodToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :alert_method, :integer, :default=>1
  end
end
