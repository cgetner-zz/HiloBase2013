# coding: UTF-8

class Employer < ActiveRecord::Base

  attr_accessible :id, :first_name, :last_name, :email, :password, :password_confirmation, :terms_of_service, :company_id, :completed_registration_step, :activated, :hashed_password, :ancestry, :parent, :parent_id, :deleted, :suspended, :tree_suspended, :spending_flag, :monthly_renew_flag
  has_ancestry
  acts_as_paranoid
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  validates :password,:on=>:create, :presence => true
  #validates_uniqueness_of :email,:message=> "Email is already taken", :case_sensitive => false
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:message=>"Email is not valid", :if => :email?
  validates_format_of :contact_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:message=>"Contact email is not valid", :if => :contact_email?
  validates_confirmation_of :password,:if => Proc.new { |job_seeker| !job_seeker.password.blank? },:message=>"Confirm Password do not match"
  #validates_format_of :password,:with=>/^(?=.*\d).{6,15}$/,:message=>"Password should be atleast 6 characters and contain atleast 1 number",:if => Proc.new { |employer| !employer.password.blank? }
  validates_acceptance_of :terms_of_service,:message=>"Please check I agree to accept terms and conditions"
  validate :validate_unique_email

  before_save :set_default_contact_email,:save_default_preferred_contact,:set_default_role
  before_destroy :update_deleted
  
  has_many :payments
  belongs_to :account_type
  belongs_to :company
  ##
  has_many :purchased_profiles
  has_many :jobs
  has_many :company_groups
  ##
  has_many :spending_limits, :dependent=>:destroy
  has_many :employer_saved_searches, :dependent=>:destroy
  has_many :employer_alerts, :dependent=>:destroy

  def update_deleted
    if self.nominated_employer_id.nil?
      self.purchased_profiles.each do |pp|
        pp.destroy
      end
      self.jobs.each do |j|
        j.destroy
      end
      self.company_groups.each do |cg|
        cg.destroy
      end
    end

    self.deleted = true
    self.request_deleted = false
    self.ancestry = nil
    self.save(:validate=>false)
  end
  
  def fetch_alerts
    EmployerAlert.find(:all, :select=>"jobs.name, job_seekers.first_name, employer_alerts.purpose, employer_alerts.job_seeker_id, employer_alerts.id" ,:joins => "join jobs on employer_alerts.job_id = jobs.id join job_seekers on employer_alerts.job_seeker_id = job_seekers.id",:conditions=>["jobs.employer_id = ? and employer_alerts.read = ?", self.id, false], :group =>"employer_alerts.id")
  end

  def self.cron_monthly_auto_renew_spending_limit
    date_diff = (DateTime.now.utc - 1.month).to_date
    emp_all = Employer.where("monthly_renew_flag = true").all
    emp_all.each do |emp|
      if emp.monthly_renew_time.to_date <= date_diff
        emp_spend = SpendingLimit.where(:employer_id => emp.id).last
        SpendingLimit.create(:employer_id => emp.id, :spend_limit => emp_spend.spend_limit, :setter_id => emp.parent_id, :available_balance => emp_spend.spend_limit)
        emp.monthly_renew_time = DateTime.now.utc
        emp.save(:validate => false)
      end
    end
  end
  
  ##RSPEC: Can't be tested
  def set_default_role
    if self.role_id.blank?
      self.role_id = 1
    end
  end

  def self_group_id
    arr = []
    self.company_groups.where(:deleted=>false).each do |i|
      arr << i.id
    end
    return arr
  end
  
  def self.generate_random_password
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten  
    str  =  (0..5).map{ o[rand(o.length)]  }.join
    str
    #Employer.encrypted_password(str)
  end

  def create_or_get_companygroup(grp_name)
    comp_grp = CompanyGroup.find(:first,:conditions=>["name like ? and company_id = ? and deleted = ?",grp_name,self.company_id, false])
    if comp_grp.blank?
      comp_grp = CompanyGroup.create({:name=>grp_name,:company_id => self.company_id})
      return comp_grp,"new_record"
    else
      return comp_grp,"old_record"
    end
  end
  
  ##RSPEC: Can't be tested
  def get_jobs_with_group(ancestors, subtree, group_id = nil)
    str1 = ancestors.join(",")
    str2 = subtree.join(",")
    select_str = "jobs.internal as internal, jobs.code as job_code, jobs.id as job_id,jobs.profile_complete as profile_complete,jobs.deleted as deleted,jobs.name as job_name,jobs.active as active,jobs.name,company_groups.id as group_id,company_groups.name as group_name,jobs.code as job_code,job_locations.street_one,job_locations.street_two,job_locations.city, employers.id, employers.first_name, employers.last_name,jobs.created_at,jobs.expire_at"
   
    conditions = " AND company_groups.deleted = 0"
    if not group_id.nil?
      conditions << " AND company_groups.id = #{group_id.to_i} "
      unless str1.blank? and str2.blank?
        return Job.select(select_str).joins("right join company_groups on jobs.company_group_id = company_groups.id left join job_locations on jobs.job_location_id = job_locations.id join employers on company_groups.employer_id = employers.id").where("employers.company_id = ? #{conditions} AND company_groups.employer_id NOT IN (#{str1}) AND company_groups.employer_id IN (#{str2})",self.company_id).order("company_groups.sort_index ASC, jobs.sort_index ASC").all
      else
        return Job.select(select_str).joins("right join company_groups on jobs.company_group_id = company_groups.id left join job_locations on jobs.job_location_id = job_locations.id join employers on company_groups.employer_id = employers.id").where("employers.company_id = ? #{conditions}",self.company_id).order("company_groups.sort_index ASC, jobs.sort_index ASC").all
      end
    else
      if str1.blank? and not str2.blank?
        return CompanyGroup.select(select_str).joins("left join jobs on company_groups.id = jobs.company_group_id left join job_locations on jobs.job_location_id = job_locations.id left join employers on company_groups.employer_id = employers.id").where("company_groups.company_id = ? #{conditions} AND company_groups.employer_id IN (#{str2})",self.company_id).order("company_groups.sort_index ASC, jobs.sort_index ASC").all
      elsif not str1.blank? and not str2.blank?
        return CompanyGroup.select(select_str).joins("left join jobs on company_groups.id = jobs.company_group_id left join job_locations on jobs.job_location_id = job_locations.id left join employers on company_groups.employer_id = employers.id").where("company_groups.company_id = ? #{conditions} AND company_groups.employer_id NOT IN (#{str1}) AND company_groups.employer_id IN (#{str2})",self.company_id).order("company_groups.sort_index ASC, jobs.sort_index ASC").all
      elsif not str1.blank? and str2.blank?
        return CompanyGroup.select(select_str).joins("left join jobs on company_groups.id = jobs.company_group_id left join job_locations on jobs.job_location_id = job_locations.id left join employers on company_groups.employer_id = employers.id").where("company_groups.company_id = ? #{conditions} AND company_groups.employer_id NOT IN (#{str1})",self.company_id).order("company_groups.sort_index ASC, jobs.sort_index ASC").all
      else
        return CompanyGroup.select(select_str).joins("left join jobs on company_groups.id = jobs.company_group_id left join job_locations on jobs.job_location_id = job_locations.id left join employers on company_groups.employer_id = employers.id").where("company_groups.company_id = ? #{conditions}",self.company_id).order("company_groups.sort_index ASC, jobs.sort_index ASC").all
      end
    end  
  end

  def get_my_positions(ancestors, descendants)
    str = ancestors.join(",")
    str1 = descendants.join(",")

    select_str = "jobs.internal as internal, jobs.code as job_code, jobs.id as job_id,jobs.profile_complete as profile_complete,jobs.deleted as deleted,jobs.name as job_name,jobs.active as active,jobs.name,company_groups.id as group_id,company_groups.name as group_name,jobs.code as job_code,job_locations.street_one,job_locations.street_two,job_locations.city, employers.id, employers.first_name, employers.last_name,jobs.created_at,jobs.expire_at"

    conditions = " AND company_groups.deleted = 0"
    if str.blank?
      str = str1
    elsif not str1.blank?
      str = str + "," + str1
    end
    if str.blank?
      return CompanyGroup.select(select_str).joins("left join jobs on company_groups.id = jobs.company_group_id left join job_locations on jobs.job_location_id = job_locations.id left join employers on company_groups.employer_id = employers.id").where("company_groups.company_id = ? #{conditions} AND employers.id IN (#{self.id})",self.company_id).order("company_groups.sort_index ASC, jobs.sort_index ASC").all
    end
    return CompanyGroup.select(select_str).joins("left join jobs on company_groups.id = jobs.company_group_id left join job_locations on jobs.job_location_id = job_locations.id left join employers on company_groups.employer_id = employers.id").where("company_groups.company_id = ? #{conditions} AND employers.id NOT IN (#{str}) AND employers.id = #{self.id}", self.company_id).order("company_groups.sort_index ASC, jobs.sort_index ASC").all
  end

  ##RSPEC: Can't be tested
  def get_groups(query="")
    _condition = "employers.id = :employer_id AND company_groups.deleted = :grp_deleted"
    _condition_hash = {:employer_id => self.id, :grp_deleted => false}
      
    if not query.blank?
      _condition << " AND company_groups.name like :query"
      _condition_hash.update({:query => "%" + query + "%"})
    end
      
    #@groups = CompanyGroup.find(:all,:joins=>"join companies on company_groups.company_id = companies.id join employers on companies.id = employers.company_id",:conditions=>[_condition,_condition_hash])
    @groups = CompanyGroup.where([_condition,_condition_hash]).joins("join companies on company_groups.company_id = companies.id join employers on companies.id = employers.company_id")
    return @groups
  end
  
  ##RSPEC: Can't be tested
  def create_my_company(comp_name,employer_id ,attr_hash = {})
    company_obj = self.company
    if company_obj.blank?
      company_obj =  self.create_or_update_company(comp_name,employer_id)
    end
        
    return company_obj if company_obj.errors.length > 0
        
    company_obj.attributes = attr_hash
    company_obj.save
    return company_obj
  end

  ##RSPEC: Can't be tested
  def create_or_update_company(comp_name,employer_id)
    company_obj =  Company.find(:first,:conditions=>["name = ?",comp_name.strip])
    if company_obj.blank?
      company_obj = Company.create({:name => comp_name, :created_by => employer_id})
    end
    return company_obj
  end
  
  def get_company
  end

  def set_company_id_if_empty(company_id)
    if self.company_id.blank? or self.company_id.to_i == 0
      self.company_id = company_id
      self.save(:validate => false)
    end
  end
  
  ##RSPEC: Can't be tested
  def set_default_contact_email
    if self.contact_email.blank?
      self.contact_email = self.email
    end
  end
  
  ##RSPEC: Can't be tested
  def save_default_preferred_contact
    if self.preferred_contact.blank?
      self.preferred_contact = "contact_email"
    end
  end
        

  def validate_unique_email
    if not self.email.blank?
      job_seeker = JobSeeker.find(:first,:conditions=>["LOWER(email) like ?",self.email.downcase])
      if not job_seeker.blank?
        errors.add("email","Email is already taken")
      end
    end
  end
  
  def password
    @password
  end
    
  def password=(pwd)
    @password = pwd
    self.hashed_password = Employer.encrypted_password(@password)
  end

  ##RSPEC: Can't be tested
  def self.authenticate_employer(login_name,login_pass)
    employer = Employer.where("email = ? and hashed_password = ? and deleted = 0 and request_deleted = 0" ,login_name,Employer.encrypted_password(login_pass)).first
  end

  def self.privileged_list
    Employer.select('employers.id, employers.company_id, employers.email, companies.name').joins("join companies on employers.company_id = companies.id").where("employers.activated = true and (employers.account_type_id = 1 or employers.account_type_id = 3)").order("companies.name ASC")
  end

  def self.right_list
    Employer.select('employers.id, employers.company_id, employers.email, companies.name').joins("join companies on employers.company_id = companies.id").where("companies.id != #{RIGHT_COMPANY_ID} AND employers.activated = true and (employers.account_type_id = 1 or employers.account_type_id = 3)").order("companies.name ASC")
  end

  def self.email_with_company
    Employer.select('employers.id, employers.company_id, employers.first_name, employers.last_name').joins("join companies on employers.company_id = companies.id").where("employers.activated = true and (employers.account_type_id = 1 or employers.account_type_id = 3)")
  end

  def equal_assign_spending_limits(node_id, amount, setter_id)
    emp = Employer.find(node_id)
    child_ids = emp.child_ids
    amount = amount.to_f / (child_ids.size + 1)
    SpendingLimit.create(:employer_id => node_id, :spend_limit => amount, :setter_id => setter_id, :available_balance => amount)
    emp.update_attribute(:spending_flag, "1")
    child_ids.each do |child_id|
      child_obj = Employer.find(child_id)
      #SpendingLimit.create(:employer_id => child_obj.id, :spend_limit => amount, :setter_id => setter_id, :available_balance => amount)
      equal_assign_spending_limits(child_obj.id, amount, setter_id)
    end
  end

  def calculus_assign_spending_limits(node_id, amount, setter_id)
    setter = Employer.find_by_id(setter_id)
    amount = amount.to_f
    total_amount = 0.0
    consumed_amt = 0.0
    diff_tree = -1.0
    emp = Employer.find(node_id)
    subtree_ids = emp.subtree_ids
    subtree_ids.each do |obj_id|
      emp_obj = Employer.find_by_id(obj_id)
      total_amount = total_amount + emp_obj.spending_limits.last.spend_limit if not emp_obj.spending_limits.last.blank?
      consumed_amt = consumed_amt + (emp_obj.spending_limits.last.spend_limit - emp_obj.spending_limits.last.available_balance)
    end
    if amount <= consumed_amt and consumed_amt != 0
      subtree_ids.each do |obj_id|
        emp_obj = Employer.find_by_id(obj_id)
        emp_obj.spending_limit_crossed_flag = true
        emp_obj.save(:validate => false)
      end
    else
      subtree_ids.each do |obj_id|
        emp_obj = Employer.find_by_id(obj_id)
        emp_obj.spending_limit_crossed_flag = false
        emp_obj.save(:validate => false)
      end
    end
    logger.info("********amount #{amount}")
    logger.info("********total_amount #{total_amount}")
    if amount > total_amount
      if not setter.spending_flag == false
        spend_amt = setter.spending_limits.last.spend_limit + (total_amount - amount)
        avail_bal = setter.spending_limits.last.available_balance + (total_amount - amount)
        SpendingLimit.create(:employer_id => setter.id, :spend_limit => spend_amt, :setter_id => setter_id, :available_balance => avail_bal)
      end
      greater_amount_assign_spending_limit(node_id, amount, amount-total_amount, setter_id)
    else
      if setter.spending_flag
        spend_amt = setter.spending_limits.last.spend_limit + (total_amount - amount)
        if amount <= consumed_amt
          diff_tree = consumed_amt - amount
          avail_bal = setter.spending_limits.last.available_balance + (total_amount - amount) - diff_tree
        else
          avail_bal = setter.spending_limits.last.available_balance + (total_amount - amount)
        end
        
        SpendingLimit.create(:employer_id => setter.id, :spend_limit => spend_amt, :setter_id => setter_id, :available_balance => avail_bal)
      else
        if amount <= consumed_amt
          diff_tree = 0.0
        end
      end
      lesser_amount_assign_spending_limit(node_id, amount, total_amount-amount, diff_tree, setter_id)
    end
  end

  def set_avail_bal_zero(node_id, amount, setter_id)
    emp = Employer.find(node_id)
    child_ids = emp.child_ids
    amount = amount.to_f / (child_ids.size + 1)
    SpendingLimit.create(:employer_id => node_id, :spend_limit => amount, :setter_id => setter_id, :available_balance => 0.0)
    child_ids.each do |child_id|
      set_avail_bal_zero(child_id, amount, setter_id)
    end
  end

  def greater_amount_assign_spending_limit(node_id, amount, diff_amount, setter_id)
    emp = Employer.find(node_id)
    diff_amt = 0.0
    child_ids = emp.child_ids
    amount = amount.to_f / (child_ids.size + 1)
    diff_amt = diff_amount.to_f / (child_ids.size + 1)
    spend_amt = emp.spending_limits.last.spend_limit + diff_amt
    avail_bal = emp.spending_limits.last.available_balance + diff_amt
    SpendingLimit.create(:employer_id => node_id, :spend_limit => spend_amt, :setter_id => setter_id, :available_balance => avail_bal)
    child_ids.each do |child_id|
      greater_amount_assign_spending_limit(child_id, amount, diff_amt, setter_id)
    end
  end

  def lesser_amount_assign_spending_limit(node_id, amount, diff_amount, diff_tree, setter_id)
    logger.info("********nodei_id #{node_id}")
    emp = Employer.find(node_id)
    diff_amt = 0.0
    child_ids = emp.child_ids
    amount = amount.to_f / (child_ids.size + 1)
    diff_amt = diff_amount.to_f / (child_ids.size + 1)
    #spend_amt = amount
    logger.info("*********emp.spending_limits.last.spend_limit #{emp.spending_limits.last.spend_limit}")
    logger.info("*******diff_amt #{diff_amt}")
    spend_amt = emp.spending_limits.last.spend_limit - diff_amt
    avail_bal = emp.spending_limits.last.available_balance - diff_amt
    logger.info("*********spend_amt #{spend_amt}")
    logger.info("*********avail_bal #{avail_bal}")
    if diff_tree.to_f >= 0.0
      avail_bal = 0.0
      spend_amt = 0.0
    end
    if avail_bal < 0.0
      if not diff_tree.to_f >= 0.0
        if emp.parent.spending_flag
          check_for_any_negative_avail_bal(node_id, avail_bal, setter_id)
          avail_bal = 0.0
        end
      end
    end
    if spend_amt < 0.0
      if not emp.parent.spending_flag == false
        check_for_any_negative_spend_limit(node_id, spend_amt, setter_id)
        spend_amt = 0.0
      end
    end
    SpendingLimit.create(:employer_id => node_id, :spend_limit => spend_amt, :setter_id => setter_id, :available_balance => avail_bal)
    child_ids.each do |child_id|
      lesser_amount_assign_spending_limit(child_id, amount, diff_amt, diff_tree, setter_id)
    end
  end

  def check_for_any_negative_avail_bal(node_id, avail_bal, setter_id)
    emp = Employer.find(node_id)
    parent_avail_bal_diff = emp.parent.spending_limits.last.available_balance + avail_bal.to_f
    spend_amt = emp.parent.spending_limits.last.spend_limit
    logger.info("*************spend_amt #{spend_amt} and avail_bal.to_f #{avail_bal.to_f}and parent_avail_bal_diff #{parent_avail_bal_diff} ")
    if parent_avail_bal_diff < 0.0
      if emp.parent.parent.spending_flag == false
        SpendingLimit.create(:employer_id => emp.parent.id, :spend_limit => spend_amt, :setter_id => setter_id, :available_balance => 0)
      else
        SpendingLimit.create(:employer_id => emp.parent.id, :spend_limit => spend_amt, :setter_id => setter_id, :available_balance => 0)
        check_for_any_negative_avail_bal(emp.parent.id, parent_avail_bal_diff, setter_id)
      end
    else
      SpendingLimit.create(:employer_id => emp.parent.id, :spend_limit => spend_amt, :setter_id => setter_id, :available_balance => parent_avail_bal_diff)
    end
  end

  def check_for_any_negative_spend_limit(node_id, spend_amt, setter_id)
    emp = Employer.find(node_id)
    parent_spend_amt_diff = emp.parent.spending_limits.last.spend_limit + spend_amt.to_f
    avail_bal = emp.parent.spending_limits.last.available_balance
    logger.info("********** emp.id #{emp.id}")
    logger.info("*******emp.parent.spending_limits.last.spend_limit #{emp.parent.spending_limits.last.spend_limit}")
    logger.info("********* spend_amt.to_f#{spend_amt.to_f}")
    logger.info("********** parent_spend_amt_diff #{parent_spend_amt_diff}")
    if parent_spend_amt_diff < 0.0
      if emp.parent.parent.spending_flag == false
        SpendingLimit.create(:employer_id => emp.parent.id, :spend_limit => 0, :setter_id => setter_id, :available_balance => avail_bal)
      else
        SpendingLimit.create(:employer_id => emp.parent.id, :spend_limit => 0, :setter_id => setter_id, :available_balance => avail_bal)
        check_for_any_negative_spend_limit(emp.parent.id, parent_spend_amt_diff, setter_id)
      end
    else
      SpendingLimit.create(:employer_id => emp.parent.id, :spend_limit => parent_spend_amt_diff, :setter_id => setter_id, :available_balance => avail_bal)
    end
  end

  def spending_limit_no(node_id)
    emp = Employer.find(node_id)
    child_ids = emp.descendant_ids
    emp.spending_flag = false
    emp.monthly_renew_flag = false
    emp.spending_limit_crossed_flag = false
    emp.save(:validate => false)
    child_ids.each do |child_id|
      spending_limit_no(child_id)
    end
  end

  def monthly_auto_renew(node_id, set)
    emp = Employer.find(node_id)
    child_ids = emp.child_ids
    emp.monthly_renew_flag = set
    emp.monthly_renew_time = DateTime.now.utc
    emp.save(:validate => false)
    #emp.update_attribute(:monthly_renew_flag, set)
    child_ids.each do |child_id|
      monthly_auto_renew(child_id, set)
    end
  end

  def delete_node_and_reassign(node_id, setter_id = nil, request = nil)
    emp = Employer.find(node_id)
    children = emp.children
    children.each do |child|
      child.parent = emp.parent
      child.save(:validate=>false)
    end
    company_groups = CompanyGroup.where(:employer_id=>emp.id).all
    company_groups.each do |folder|
      folder.employer_id = emp.parent_id
      folder.save(:validate => false)
    end
    emp.jobs.each do |job|
      job.employer_id = emp.parent_id
      job.save(:validate => false)
    end
    emp_parent = Employer.find(emp.parent_id)
    #reallocation of available balance
    if emp_parent.spending_flag
      current_sl = SpendingLimit.where(:employer_id => emp.id).last
      parent_sl = SpendingLimit.where(:employer_id => emp.parent_id).last
      if not current_sl.nil? or not parent_sl.nil?
        SpendingLimit.create(:employer_id => parent_sl.employer_id, :spend_limit => (parent_sl.spend_limit + current_sl.spend_limit), :setter_id => setter_id, :available_balance => (parent_sl.available_balance + current_sl.available_balance))
      end
    end
    #
    emp.ancestry = nil
    emp.deleted = true
    if !request.nil?
      sender_name = emp_parent.first_name+" "+emp_parent.last_name
      Notifier.mail_to_deleted_user(emp.email, sender_name, request).deliver
    end
    emp.save(:validate=>false)
  end

  def suspend_tree(node_id, request)
    emp = Employer.find(node_id)
    emp.suspended = true
    sender_name = emp.parent.first_name+" "+emp.parent.last_name
    Notifier.mail_to_suspended_user(emp.email, sender_name, request).deliver
    emp.save!(:validate=>false)
    suspend_descendants(emp, sender_name, request)
    #may send mail here for suspended users
  end

  def suspend_descendants(emp, sender_name, request)
    descendants = emp.descendants
    descendants.each do |d|
      d.tree_suspended = true
      Notifier.mail_to_suspended_user(d.email, sender_name, request).deliver
      d.save(:validate=>false)
    end
  end

  def reinstate_nodes(node_id, request)
    emp = Employer.find(node_id)
    emp.suspended = false
    Notifier.mail_to_reinstate_user(emp.email, request).deliver
    emp.save!(:validate=>false)
    reinstate_descendants(emp, request)
  end

  def reinstate_descendants(emp, request)
    descendants = emp.descendants
    descendants.each do |d|
      d.tree_suspended = false
      Notifier.mail_to_reinstate_user(d.email, request).deliver
      d.save(:validate=>false)
    end
  end

  def spending_limit_crossed(node_id, amount, employer_id)
    emp = Employer.find(node_id)
    if not emp.spending_limits.blank? and emp.spending_flag
      total_amount = 0.0
      available_amt = 0.0
      emp.subtree_ids.each do |child_sub|
        emp_obj = Employer.find_by_id(child_sub)
        total_amount = total_amount + emp_obj.spending_limits.last.spend_limit if not emp_obj.spending_limits.last.blank?
        available_amt = available_amt + emp_obj.spending_limits.last.available_balance if not emp_obj.spending_limits.last.blank?
      end
      consumed_amt = total_amount - available_amt
      if consumed_amt >= amount.to_f and consumed_amt != 0.0
        return consumed_amt - amount.to_f
      else
        employer = Employer.find_by_id(employer_id)
        if employer.is_root?
          return -1
        else
          if employer.spending_flag
            diff = (employer.spending_limits.last.available_balance + total_amount) - amount.to_f
            logger.info("***********employer.spending_limits.last.available_balance + total_amount #{employer.spending_limits.last.available_balance + total_amount}")
            logger.info("********amount.to_f #{amount.to_f}")
            logger.info("********total_amount #{total_amount}")
            if employer.spending_limits.last.available_balance.round(4) + total_amount < amount.to_f
              return "limit_crossed_"+diff.to_s
            else
              #total = 0.0
              #employer.descendant_ids.each do |e_child|
              #  emp_obj = Employer.find_by_id(e_child)
              #  total = total + emp_obj.spending_limits.last.spend_limit
              #end
              #allocated = total + amount.to_f - total_amount
              return "under_limit"
            end
          else
            return "under_limit"
          end
        end
      end
    else
      return -1
    end
  end

  def self.subtree_total_spend_limit(emp)
    total_amount = 0
    emp.subtree_ids.each do |child_sub|
      emp_obj = Employer.find_by_id(child_sub)
      total_amount = total_amount + emp_obj.spending_limits.last.spend_limit if not emp_obj.spending_limits.last.blank?
    end
    total_amount
  end

  def self_delete
    begin
        case self.account_type_id
        when 1 #root
          if self.nominated_employer_id.present?
            self.descendants.each do |sub|
              sub.spending_flag = false
              sub.save(:validate=>false)
            end
            nominated = Employer.find_by_id(self.nominated_employer_id)
            nominated.ancestry = nil
            nominated.account_type_id = 1
            nominated.save(:validate=>false)
            Notifier.new_root(nominated).deliver
            self.children.each do |c|
              if c != nominated
                c.parent = nominated
                c.save(:validate=>false)
              end
            end
            ##
            #send email
            Notifier.delete_root(self).deliver
            #reassigning folders and positions
            self.company_groups.each do |cg|
              cg.jobs.each do |j|
                j.employer_id = nominated.id
                j.sort_index = j.id
                j.save(:validate=>false)
              end
              cg.employer_id = nominated.id
              cg.sort_index = cg.id
              cg.save(:validate=>false)
            end
            ##
            self.destroy
            ##
          else
            #no nomination
            c = self.company
            self.subtree.each do |e|
              #send email
              if e.is_root?
                Notifier.delete_root(e).deliver
              else
                Notifier.delete_child(e).deliver
              end
              logger.info "***************************************************************Deleting #{e.id}"
              e.destroy
            end
            #what happens to all the internal candidates?
            #deleting internal candidates
            c.destroy
          end
        when 2 #child
          #sending notification to the hierarchy above
          self.ancestors.each do |emp|
            ea = EmployerAlert.create(:purpose=>"sub-deleted", :read=>false, :new=>true, :employer_id => emp.id, :deleted_employer_id => self.id)
            if emp.alert_method == ON_EVENT_EMAIL and !emp.request_deleted
              email_hash = {:employer_first_name => emp.first_name, :employer_email => emp.email, :employer_alerts => ea.id}
              Notifier.email_employer_notifications(email_hash).deliver
              emp.notification_email_time = DateTime.now
              emp.save(:validate => false)
            end
          end
          self.delete_node_and_reassign(self.id)
          Notifier.delete_child(self).deliver
          self.request_deleted = false
          self.deleted_at = Time.now
          self.save(:validate=>false)
        when 3 #single
          c = self.company
          Notifier.delete_single(self).deliver
          self.destroy
          #what happens to all the internal candidates?
          #deleting internal candidates
          c.destroy
        end
    rescue
      self.request_deleted = true
      self.nominated_employer_id = nil
      self.save(:validate=>false)
    end
  end
        
  private
   
  def self.encrypted_password(pwd)
    Digest::SHA1.hexdigest(pwd)
  end
  
end