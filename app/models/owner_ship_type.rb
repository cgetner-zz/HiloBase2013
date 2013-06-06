# coding: UTF-8

class OwnerShipType < ActiveRecord::Base
  attr_accessible :name
  has_many :companies

end
