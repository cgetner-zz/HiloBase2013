class University < ActiveRecord::Base
 attr_accessible :institution, :activated

 has_many :added_universities, :dependent => :destroy
 has_many :job_seekers, :through => :added_universities
 has_many :jobs, :through => :added_universities
end
