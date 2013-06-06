class AddedRole < ActiveRecord::Base
  attr_accessible :adder_id, :adder_type, :code,:education_level_id, :experience_level_id
  audited
  belongs_to :job_seeker, :foreign_key => "adder_id"
  belongs_to :occupation_data, :foreign_key => "code"
  belongs_to :job, :foreign_key => "adder_id"
  
  belongs_to :education_level
  belongs_to :experience_level
end
