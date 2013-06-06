# coding: UTF-8

class CreateJobSeekers < ActiveRecord::Migration
  def self.up
    create_table :job_seekers, :options => "ENGINE=InnoDB" do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :hashed_password
      t.string :phone_one
      t.string :phone_two
      t.string :contact_email
      t.boolean :activated, :default=> false
      t.timestamps
    end
  end

  def self.down
    drop_table :job_seekers
  end
end
