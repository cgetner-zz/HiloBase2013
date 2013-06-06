# coding: UTF-8

class AddCaptionToCreativeSamples < ActiveRecord::Migration
  def self.up
      add_column :creative_samples,:caption,:string
  end

  def self.down
    remove_column :creative_samples,:caption
  end
end
