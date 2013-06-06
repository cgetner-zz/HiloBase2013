class LayTitle < ActiveRecord::Base
  self.table_name = 'lay_titles'
  attr_accessible :soc_code, :soc_title, :onetsoc_code, :onetsoc_title, :lay_title, :title_type, :source
  belongs_to :occupation_data, :foreign_key=>"onetsoc_code"
end
