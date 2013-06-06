# coding: UTF-8

class JobLocation < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :city, :state, :country, :street_one, :street_two, :zip_code
  has_one :job
#  geocoded_by :address
#  after_validation :geocode
  audited

end
