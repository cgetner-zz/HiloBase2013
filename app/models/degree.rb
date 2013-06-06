class Degree < ActiveRecord::Base

   attr_accessible :name, :value

   has_many :added_degrees, :dependent => :destroy
   has_many :job_seekers, :through => :added_degrees
   has_many :jobs, :through => :added_degrees

end
