class ExperienceLevel < ActiveRecord::Base
  attr_accessible :name, :score

  has_many :added_roles
end
