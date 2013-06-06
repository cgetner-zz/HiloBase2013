class CreateCompanyDomains < ActiveRecord::Migration
  def change
    create_table :company_domains do |t|
      t.integer :company_id
      t.string :domain

      t.timestamps
    end
  end
end
