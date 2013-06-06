class JobSeekerDegree < ActiveRecord::Base
    belongs_to :job_seeker
    belongs_to :degree
end
