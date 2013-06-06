class ContentModelReference < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :element_id, :element_name, :description
end
