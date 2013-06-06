# coding: UTF-8

class ProfileResponsibility < ActiveRecord::Base
  attr_accessible :name

  has_many :job_profile_responsibilities, :dependent => :destroy
  has_many :jobs, :through => :job_profile_responsibilities
  
  
  def self.create_or_get_responsibility(resp_name)
      resp_obj = ProfileResponsibility.find(:first,:conditions=>["name = ? ",resp_name.strip])
      if resp_obj.blank?
          resp_obj = ProfileResponsibility.create({:name=> resp_name.strip})
      end
      return resp_obj
  end

end
