# coding: UTF-8

class CreateCompanyGroups < ActiveRecord::Migration
  def self.up
    create_table :company_groups, :options => "ENGINE=InnoDB" do |t|
      t.string :name
      t.integer :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :company_groups
  end
end
