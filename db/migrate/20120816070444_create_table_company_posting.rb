class CreateTableCompanyPosting < ActiveRecord::Migration
  def up
    create_table :company_postings do |t|

      t.integer :company_id
      t.integer :hilo_count, :default=>0
      t.integer :facebook_count, :default=>0
      t.integer :twitter_count, :default=>0
      t.integer :linkedin_count, :default=>0
      t.integer :url_count, :default=>0

      t.timestamps
    end
  end

  def down
    drop_table :company_postings
  end
end
