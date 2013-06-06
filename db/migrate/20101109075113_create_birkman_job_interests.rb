# coding: UTF-8

class CreateBirkmanJobInterests < ActiveRecord::Migration
  def self.up
    create_table :birkman_job_interests, :options => "ENGINE=InnoDB" do |t|
      t.string :statement
      t.integer :set_number
      t.timestamps
    end
  end

  def self.down
    drop_table :birkman_job_interests
  end
end
