# coding: UTF-8

class CreateCertificates < ActiveRecord::Migration
  def self.up
    create_table :certificates, :options => "ENGINE=InnoDB" do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :certificates
  end
end
