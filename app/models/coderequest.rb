# coding: UTF-8

class Coderequest < ActiveRecord::Base

  attr_accessible :email
  
  validates :email, :presence=>true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message=>"Email is not valid", :if => :email?
  validates_uniqueness_of :email, :message=> "Email is already taken", :case_sensitive=>false

end
