class AccessLevel < ActiveRecord::Base
  attr_accessible :name

  has_many :admin_access_levels
  has_many :administrators, :through => :admin_access_levels
  #has_many :admin_access_levels, :as => :level
end
