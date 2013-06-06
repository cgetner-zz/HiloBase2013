class AddedDegree < ActiveRecord::Base
  attr_accessible :adder_id, :adder_type, :degree_status, :degree_id, :required_flag
  audited
  belongs_to :degree
  belongs_to :job_seeker
  belongs_to :job
end
