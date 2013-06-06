# coding: UTF-8

class JobProfileResponsibility < ActiveRecord::Base
  belongs_to :job
  belongs_to :profile_responsibility
  audited
end
