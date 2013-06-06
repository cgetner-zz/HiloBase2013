# coding: UTF-8

class Posting < ActiveRecord::Base
  attr_accessible :hilo_share, :hilo_count
  belongs_to :job
end
