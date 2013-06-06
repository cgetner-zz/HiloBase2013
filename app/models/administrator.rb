class Administrator < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :first_name,:last_name, :active
  has_secure_password

  has_many :admin_access_levels
  has_many :access_levels, :through => :admin_access_levels
  #has_many :admin_access_levels, :as => :level
end
