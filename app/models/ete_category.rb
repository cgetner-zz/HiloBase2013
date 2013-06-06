class EteCategory < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :element_id, :scale_id, :category, :category_description
end
