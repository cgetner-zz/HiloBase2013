# coding: UTF-8

class BirkmanJobInterest < ActiveRecord::Base
  attr_accessible :statement, :set_number
  translates :statement
end
