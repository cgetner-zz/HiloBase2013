# coding: UTF-8

class CreateCoderequests < ActiveRecord::Migration
  def self.up
    create_table :coderequests do |t|
	 t.string :email
	 t.integer :promotional_code_id
      t.timestamps
    end
  end

  def self.down
    drop_table :coderequests
  end
end
