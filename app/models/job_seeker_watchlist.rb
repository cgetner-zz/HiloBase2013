# coding: UTF-8

class JobSeekerWatchlist < ActiveRecord::Base
  attr_accessible :job_id, :job_seeker_id
  belongs_to :job_seeker
end
