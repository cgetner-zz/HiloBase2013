class CreateAccessLevels < ActiveRecord::Migration
  def change
    create_table :access_levels do |t|
      t.string :name
      t.timestamps
    end
    AccessLevel.create!(:name => "All")
    AccessLevel.create!(:name => "Employer Privileges")
    AccessLevel.create!(:name => "Referral Fee")
    AccessLevel.create!(:name => "Corporate Accounts")
  end
end
