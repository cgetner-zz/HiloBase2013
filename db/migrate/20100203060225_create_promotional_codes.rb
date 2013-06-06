# coding: UTF-8

class CreatePromotionalCodes < ActiveRecord::Migration
  def self.up
    create_table :promotional_codes, :options => "ENGINE=InnoDB" do |t|
      t.text :code
      t.integer :job_seeker_id
      t.float :discount_amount_usd
      t.timestamps
    end
  end

  def self.down
    drop_table :promotional_codes
  end
end
