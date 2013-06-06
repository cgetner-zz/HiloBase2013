# coding: UTF-8

class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.boolean :hilo_share
      t.boolean :facebook_share
      t.boolean :linkedin_share
      t.boolean :twitter_share
      t.integer :job_id
      t.integer :employer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :postings
  end
end
