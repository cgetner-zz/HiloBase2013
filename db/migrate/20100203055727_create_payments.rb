# coding: UTF-8

class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments , :options => "ENGINE=InnoDB" do |t|
      t.float :amount_charged
      t.string :id_of_transaction
      t.string :paypal_status
      t.text :log_message
      t.boolean :payment_success
      t.text :billing_address_one
      t.text :billing_address_two
      t.string :billing_city
      t.string :billing_state
      t.string :billing_zip
      t.string :billing_country
      t.string :payment_purpose
      t.integer :promotional_code_id
      t.string :payment_mode
      t.string :payer_id
      t.string :token_value
      t.integer :job_seeker_id
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
