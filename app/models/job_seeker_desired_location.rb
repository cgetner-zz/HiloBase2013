# coding: UTF-8

class JobSeekerDesiredLocation < ActiveRecord::Base
  attr_accessible :desired_location_id, :city, :latitude, :longitude
  belongs_to :job_seeker
#  geocoded_by :address
#  after_validation :geocode
end
