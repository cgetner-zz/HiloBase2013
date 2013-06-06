class CareerSeekerSavedSearch < ActiveRecord::Base
  attr_accessible :job_seeker_id, :keyword, :name, :deleted
  belongs_to :job_seeker
  audited
end
