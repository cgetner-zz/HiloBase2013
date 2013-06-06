class AddHiloSubscriptionToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :hilo_subscription, :boolean, :default=>false
  end
end
