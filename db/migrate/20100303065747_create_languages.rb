# coding: UTF-8

class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages, :options => "ENGINE=InnoDB" do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :languages
  end
end
