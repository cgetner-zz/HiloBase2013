class AddingLayTitlesTableForRoles < ActiveRecord::Migration
  def up
    create_table :lay_titles, :options => "ENGINE=MyISAM" do |t|
      t.string :soc_code
      t.string :soc_title
      t.string :onetsoc_code
      t.string :onetsoc_title
      t.string :lay_title
      t.string :title_type
      t.float :source
    end
    require 'csv'
    cmr_path = File.join(Rails.root, "public/csv_files/lay_titles.csv")
    CSV.foreach(cmr_path) do |row|
      LayTitle.create!(:id => row[0], :soc_code => row[1], :soc_title => row[2], :onetsoc_code => row[3], :onetsoc_title => row[4], :lay_title => row[5], :title_type => row[6], :source => row[7])
    end
  end

  def down
    drop_table :lay_titles
  end
end
