class CreateEmployerPrivileges < ActiveRecord::Migration
  def up
    create_table :employer_privileges do |t|
      t.integer :company_id
      t.boolean :status, :default => false
      t.float :credit_value, :default => 0.0
      t.float :discount_value, :default => 0.0
      t.timestamps
    end
  end

  def down
    drop_table :employer_privileges
  end
end
