class IcsType < ActiveRecord::Base
  attr_accessible :type
  has_many :job_seekers
end
