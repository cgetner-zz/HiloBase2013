class AddedUniversity < ActiveRecord::Base
  attr_accessible :adder_id, :adder_type, :university_id
  audited
  belongs_to :job_seeker
  belongs_to :university
end
