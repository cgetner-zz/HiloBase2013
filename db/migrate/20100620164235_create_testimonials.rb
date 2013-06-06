# coding: UTF-8

class CreateTestimonials < ActiveRecord::Migration
  def self.up
    create_table :testimonials, :options => "ENGINE=InnoDB"  do |t|
      t.string :testimonial_by
      t.string :name
      t.string :position
      t.string :description
      t.boolean :display,:default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :testimonials
  end
end
