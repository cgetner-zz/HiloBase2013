# coding: UTF-8

class CompanyGroup < ActiveRecord::Base
  attr_accessible :deleted, :name, :company_id, :employer_id
  validates :name, :presence=>true
  validates :company_id, :presence=>true
  #validates_uniqueness_of :name,:scope=>[:company_id],:message=>"Group name already exists"
  has_many :jobs
  belongs_to :employer
  
  after_create :fill_list_order
  
  ##RPSEC: Can't be tested
  def fill_list_order
      self.sort_index = self.id
      self.save(:validate => false)
  end
  
  def self.remove(company_id, group_id)
    self.update_all({:deleted => true},["id = #{group_id.to_i} and company_id = #{company_id.to_i}"])
    Job.update_all({:deleted => true}, ['company_group_id =  ?', group_id.to_i])
    #JobSeeker feed
#    Job.where(:company_group_id => group_id.to_i).each do |job|
#      job_ids = Array.new
#      job_ids<<job.id
#      if job.active
#        if job.internal
#          js_ids = JobSeeker.where(:company_id => job.company_id, :activated => true).map{|js| js.id}
#          BroadcastController.new.delay(:priority => 6).opportunities_internal(job.company_id, js_ids)
#          js_ids.each do |id|
#            BroadcastController.new.delay(:priority => 6).xref_update(id, job.company_id, job_ids)
#          end
#        else
#          BroadcastController.new.delay(:priority => 6).opportunities_internal(job.company_id, JobSeeker.where(:company_id => job.company_id, :activated => true).map{|js| js.id})
#          BroadcastController.new.delay(:priority => 6).opportunities_normal(JobSeeker.where(:company_id=>nil, :activated => true).map{|js| js.id})
#          js_ids = JobSeeker.where("company_id = #{job.company_id} OR company_id IS NULL AND activated = #{true}").map{|js| js.id}
#          js_ids.each do |id|
#            BroadcastController.new.delay(:priority => 6).xref_update(id, job.company_id, job_ids)
#          end
#        end
#
#        job.employer.ancestor_ids.each do |id|
#          BroadcastController.new.delay(:priority => 6).employer_dashboard(id, -1)
#        end
#        BroadcastController.new.delay(:priority => 6).employer_dashboard(job.employer.id, -1)
#      end
#    end



    #changes (checked)
    jobs = Job.where(:company_group_id => group_id.to_i)
    BroadcastController.new.employer_update(company_id.to_i, "dashboard", jobs.map{|m| m.id}, [])
    BroadcastController.new.employer_update(company_id.to_i, "xref", jobs.map{|m| m.id}, JobSeeker.where(:activated=>true).map{|m| m.id})

    jobs.each do |job|
      if job.active
        if job.internal
          job.company.path_ids.each do |c|
            BroadcastController.new.opportunities_internal(c, JobSeeker.where(:company_id => job.company.path_ids, :activated => true).map{|js| js.id})
          end
        else
          job.company.path_ids.each do |c|
            BroadcastController.new.opportunities_internal(c, JobSeeker.where(:company_id => job.company.path_ids, :activated => true).map{|js| js.id})
          end
          BroadcastController.new.opportunities_normal(JobSeeker.where(:company_id=>nil, :activated => true).map{|js| js.id})
        end
      end
    end
    



  end
  
end
