class EmployerSavedSearch < ActiveRecord::Base
  attr_accessible :employer_id, :keyword, :name
  belongs_to :employer
end
