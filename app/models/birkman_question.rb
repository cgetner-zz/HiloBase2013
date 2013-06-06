# coding: UTF-8

class BirkmanQuestion < ActiveRecord::Base
  attr_accessible :question, :set_number

  translates :question
end
