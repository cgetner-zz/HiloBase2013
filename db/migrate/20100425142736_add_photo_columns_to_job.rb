# coding: UTF-8

class AddPhotoColumnsToJob < ActiveRecord::Migration
  def self.up
    
      add_column :jobs,:photoone_file_name,:string
      add_column :jobs,:photoone_content_type,:string
      add_column :jobs,:photoone_file_size,:string
      
      add_column :jobs,:phototwo_file_name,:string
      add_column :jobs,:phototwo_content_type,:string
      add_column :jobs,:phototwo_file_size,:string
      
      
      
  
  end

  def self.down
      remove_column :jobs,:photoone_file_name
      remove_column :jobs,:photoone_content_type
      remove_column :jobs,:photoone_file_size
      remove_column :jobs,:phototwo_file_name
      remove_column :jobs,:phototwo_content_type
      remove_column :jobs,:phototwo_file_size
      
      
  end
end
