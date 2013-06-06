class PopulateMissingRoleData < ActiveRecord::Migration
  def up
    require 'csv'
    cmr_path = File.join(Rails.root, "public/csv_files/content_model_reference.csv")
    CSV.foreach(cmr_path) do |row|
      ContentModelReference.create!(:element_id => row[0], :element_name => row[1], :description => row[2])
    end
    ec_path = File.join(Rails.root, "public/csv_files/ete_categories.csv")
    CSV.foreach(ec_path) do |row|
      EteCategory.create!(:element_id => row[0], :scale_id => row[1], :category => row[2], :category_description => row[3])
    end
    od_path = File.join(Rails.root, "public/csv_files/occupation_data.csv")
    CSV.foreach(od_path) do |row|
      OccupationData.create!(:onetsoc_code => row[0], :title => row[1], :description => row[2])
    end
  end

  def down
  end
end
