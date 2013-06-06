# coding: UTF-8
require 'open-uri'

class Job < ActiveRecord::Base

  attr_accessible :company_group_id, :sort_index, :name, :employer_id, :armed_forces, :summary, :company_id, :hiring_company,
    :hiring_company_name, :website_one, :website_title_one, :website_two, :website_title_two, :website_three, :website_title_three, :id,
    :remote_work, :job_location_id, :old_employer_id, :grid_work_environment_x, :grid_work_environment_y, :grid_work_role_x, :grid_work_role_y,
    :internal, :minimum_compensation_amount, :job_link, :vendor_job_id, :xml_import_pairing_logic, :salary_not_disclosed, :maximum_compensation_amount

  audited
  acts_as_paranoid

  validates :name, :presence=>true
  validates :summary, :presence=>true
  validates :company_id, :presence=>true
  validates :employer_id, :presence=>true
  validates :company_group_id, :presence=>true
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :code, :message => "Career Code is already taken"

  belongs_to :job_location
  belongs_to :company_group
  belongs_to :company
  belongs_to :employer

  #has_many :employer_alerts
  has_many :job_statuses, :dependent=>:destroy
  has_many :job_criteria_desired_employments,:dependent=>:destroy
  has_many :desired_employments,:through=>:job_criteria_desired_employments
  has_many :job_criteria_certificates,:dependent=>:destroy
  has_many :new_certificates, :through=>:job_criteria_certificates
  has_many :pairing_logics, :dependent=>:destroy
  has_many :licenses, :through=>:job_criteria_certificates
  has_many :job_criteria_languages,:dependent=>:destroy
  has_many :languages,:through =>:job_criteria_languages
  has_many :job_workenv_questions,:dependent=>:destroy
  has_many :job_role_questions,:dependent=>:destroy
  has_one :channel_manager, :dependent => :destroy
  has_one :posting, :dependent => :destroy
  has_many :added_universities, :foreign_key => "adder_id", :dependent => :destroy, :conditions => "added_universities.adder_type = 'JobPosition'"
  has_many :universities, :through => :added_universities, :conditions => "added_universities.adder_type = 'JobPosition'"
  has_many :added_degrees, :foreign_key => "adder_id", :dependent => :destroy, :conditions => "added_degrees.adder_type = 'JobPosition'"
  has_many :degrees, :through => :added_degrees, :conditions => "added_degrees.adder_type = 'JobPosition'"
  has_many :added_roles, :foreign_key => "adder_id", :dependent => :destroy, :conditions => "added_roles.adder_type = 'JobPosition'"
  has_many :occupation_data, :foreign_key => "adder_id", :through => :added_roles, :conditions => "added_roles.adder_type = 'JobPosition'"
  has_many :job_profile_responsibilities, :dependent => :destroy
  has_many :profile_responsibilities, :through => :job_profile_responsibilities, :order => :created_at, :dependent=>:destroy
  has_many :job_seeker_watchlists, :dependent => :destroy
  has_many :log_job_shares, :dependent => :destroy
  has_many :log_shares, :dependent => :destroy
  has_many :job_attachments, :dependent => :destroy
  has_many :purchased_profiles
  #has_many :job_seeker_notifications, :dependent => :destroy

  #no longer in use
  has_many :job_criteria_degrees,:dependent=>:destroy
  has_many :degrees,:through =>:job_criteria_degrees
  has_many :job_criteria_proficiencies,:dependent=>:destroy
  has_many :proficiencies,:through=>:job_criteria_proficiencies

  accepts_nested_attributes_for :job_attachments, :allow_destroy => true

  searchable :auto_index => false do

    text :desired_employments do |job|
      job.desired_employments.map {|desired_employment| desired_employment.name}
    end

    text :job_location_city do
      if active == true
        if remote_work == false
          job_location.city
        else
          "virtual"
        end
      end
    end

    text :job_location_street_one do
      job_location.street_one if remote_work == false and active == true
    end

    text :job_location_street_two do
      job_location.street_two if remote_work == false and active == true
    end

    text :job_location_state do
      job_location.state if remote_work == false and active == true
    end

    text :job_location_country do
      job_location.country if remote_work == false and active == true
    end

    text :degrees do |job|
      job.degrees.map {|degree| degree.name}
    end

    text :new_certificates do |job|
      job.new_certificates.map {|new_certificate| new_certificate.certification_name}
    end

    text :licenses do |job|
      job.licenses.map {|license| license.license_name}
    end

    text :languages do |job|
      job.languages.map {|language| language.name}
    end

    text :universities do |job|
      job.universities.map {|university| university.institution}
    end

    text :summary, :name

    text :roles do |job|
      job.occupation_data.map {|od| od.title}
    end

    text :profile_responsibilities do |job|
      job.profile_responsibilities.map {|pr| pr.name}
    end

  end

  #TODO : uncomment for paperclip end
  #before_save :set_expire_at_for_job

  before_destroy :delete_job_location_and_send_notifications
  after_create :auto_generate_job_code,:fill_list_order

  def delete_job_location_and_send_notifications
    self.job_location.destroy if !self.remote_work and !self.job_location.nil?
    dir_path = ''
    self.job_attachments.each do |job_attachment|
      dir_path = File.expand_path(File.dirname(job_attachment.attachment.path))
      #File.expand_path(File.dirname(job_attachment.attachment.path))
    end
    FileUtils.remove_dir(dir_path, force = true)
    begin
      if self.active
        if self.internal
          js_ids = JobSeeker.where(:company_id => self.company.path_ids, :activated => true).map{|js| js.id}
          self.job.path_ids.each do |c|
            BroadcastController.new.opportunities_internal(c, js_ids)
          end
        else
          self.job.path_ids.each do |c|
            BroadcastController.new.opportunities_internal(c, JobSeeker.where(:company_id => self.company.path_ids, :activated => true).map{|js| js.id})
          end
          BroadcastController.new.opportunities_normal(JobSeeker.where(:company_id=>nil, :activated => true).map{|js| js.id})
        end
      end
    rescue
    end

    self.active = false
    self.internal = false
    self.deleted = true
    self.save(:validate=>false)

  end

  def fill_list_order
    self.sort_index = self.id
    self.save(:validate => false)
  end

  def auto_generate_job_code
    self.code = "HL" + self.id.to_s
    self.save(:validate => false)
  end

  def save_work_env_score
    x_score, y_score =  self.work_env_score
    self.grid_work_environment_x = x_score
    self.grid_work_environment_y = y_score
    self.save(:validate => false)
  end

  def self.activate_by_employer(job_id,employer_id)
    j = Job.find(job_id)
    j.toggle :active
    j.save
  end

  def language_skill_proficiency
    Job.select("languages.*,job_criteria_languages.*").joins("inner join job_criteria_languages on jobs.id = job_criteria_languages.job_id join languages on languages.id = job_criteria_languages.language_id").where("jobs.id = ?", self.id).all
  end

  def certification_required
    Job.select("certificates.*,job_criteria_certificates.*").joins("inner join job_criteria_certificates on jobs.id = job_criteria_certificates.job_id join certificates on certificates.id = job_criteria_certificates.certificate_id").where("jobs.id = ?", self.id).all
  end

  def work_env_score
    x_score = 0
    y_score = 0
    jw_questions = JobWorkenvQuestion.select("job_workenv_questions.*,workenv_questions.xscoring,workenv_questions.yscoring").joins("join workenv_questions on job_workenv_questions.workenv_question_id = workenv_questions.id").where("job_workenv_questions.job_id = ?",self.id).all

    if jw_questions.length > 0
      for jw in jw_questions
        if jw.xscoring=="POS"
          x_score= x_score + jw.score.to_i
        elsif
          jw.xscoring=="NEG"
          x_score= x_score + (4 - jw.score.to_i)
        end

        if jw.yscoring=="POS"
          y_score= y_score + jw.score.to_i
        elsif
          jw.yscoring=="NEG"
          y_score= y_score + (4 - jw.score.to_i)
        end
      end
      map_score_x = $work_env_map_x[x_score]
      map_score_y = $work_env_map_y[y_score]
    elsif !self.grid_work_environment_x.nil? and !self.grid_work_environment_y.nil?
      map_score_x = self.grid_work_environment_x
      map_score_y = self.grid_work_environment_y
    else
      map_score_x = -1
      map_score_y = -1
    end

    return map_score_x,map_score_y
  end

  def save_role_env_score
    x_score_role, y_score_role =  self.role_score
    self.grid_work_role_x = x_score_role
    self.grid_work_role_y = y_score_role
    self.save(:validate => false)
  end

  def role_score
    x_score_role = 0
    y_score_role = 0

    jr_questions = JobRoleQuestion.select("job_role_questions.*,role_questions.xscoring,role_questions.yscoring").joins("join role_questions on job_role_questions.role_question_id = role_questions.id").where("job_role_questions.job_id = ?",self.id).all

    if jr_questions.length > 0
      for jr in jr_questions
        if jr.xscoring == "POS"
          x_score_role = x_score_role + jr.score.to_i
        elsif jr.xscoring == "NEG"
          x_score_role = x_score_role + (4 - jr.score.to_i)
        end

        if jr.yscoring == "POS"
          y_score_role = y_score_role + jr.score.to_i
        elsif jr.yscoring == "NEG"
          y_score_role = y_score_role + (4 - jr.score.to_i)
        end
      end

      map_score_x = $role_score_map_x[x_score_role]
      map_score_y = $role_score_map_y[y_score_role]
    elsif !self.grid_work_role_x.nil? and !self.grid_work_role_y.nil?
      map_score_x = self.grid_work_role_x
      map_score_y = self.grid_work_role_y
    else
      map_score_x = -1
      map_score_y = -1
    end

    return map_score_x,map_score_y
  end

  def add_proficiencies(prof_ids)
    JobCriteriaProficiency.delete_all("job_id = '#{self.id}'")
    if prof_ids.blank?
      return
    end

    for prof_id in prof_ids.split(",")
      begin
        prof_obj = Proficiency.find(prof_id)
        self.proficiencies << prof_obj
      rescue ActiveRecord::RecordNotFound
      end
    end
  end

  def employer_add_proficiencies(prof_ids, created_by_id)
    JobCriteriaProficiency.delete_all("job_id = '#{self.id}'")
    if not prof_ids.blank?
      for prof_id in prof_ids
        begin
          pro = Proficiency.find_by_name(prof_id)
          if pro.nil?
            pro = Proficiency.create({:name=>prof_id,:created_by=>created_by_id,:activated=>"0"})
          end
          self.job_criteria_proficiencies << JobCriteriaProficiency.new({:proficiency_id => pro.id})
        rescue ActiveRecord::RecordNotFound
        end
      end
    end
  end

  def add_languages(lang_hash,required_languages_flag)
    JobCriteriaLanguage.delete_all("job_id = '#{self.id}'")
    cnt = 0
    lang_hash.each{|k,v|
      begin
        lang = Language.find(k)
        job_criteria_language = JobCriteriaLanguage.new({:language_id => k,:proficiency_val => v})
        if !required_languages_flag.blank? and required_languages_flag[cnt] == "1"
          job_criteria_language.required_flag = true
        end
        self.job_criteria_languages << job_criteria_language
      rescue ActiveRecord::RecordNotFound
      end
      cnt  = cnt + 1
    }
  end

  def add_languages_new(lang_hash, required_languages_flag)
    if !lang_hash.blank?
      JobCriteriaLanguage.delete_all("job_id = '#{self.id}'")
      cnt = 0
      lang_arr = lang_hash.split(",")

      lang_arr.each{|lang|
        lang_each = lang.split("__")
        #lang_name = Language.find(lang_each[0])
        begin
          job_criteria_language = JobCriteriaLanguage.new({:language_id => lang_each[0],:proficiency_val => lang_each[1]})
          if !required_languages_flag.blank? and required_languages_flag[cnt] == "1"
            job_criteria_language.required_flag = true
          end
          self.job_criteria_languages << job_criteria_language
        rescue ActiveRecord::RecordNotFound
        end
        cnt=cnt+1
      }
    end
  end

  def employer_add_languages(lang_hash,required_languages_flag)
    temp_hash = {}
    lang_hash.each{|k,v|
      k = k.to_s
      temp_hash.update({k => v})
    }
    JobCriteriaLanguage.delete_all("job_id = '#{self.id}'")
    cnt = 0
    temp_hash.keys.each{|arr|
      if arr!=""
        begin
          lang = Language.where(:name=>arr).first
          job_criteria_language = JobCriteriaLanguage.new({:language_id => lang.id,:proficiency_val => temp_hash[arr]})
          if !required_languages_flag.blank? and required_languages_flag[cnt] == "1"
            job_criteria_language.required_flag = true
          end
          self.job_criteria_languages << job_criteria_language
        rescue ActiveRecord::RecordNotFound
        end
        cnt  = cnt + 1
      end
    }
  end

  def set_expire_at_for_job
    if not self.profile_complete == true
      if self.expire_at.blank?
        self.expire_at = Time.now + (60 * 24 * 60 * 60)
      end
    end
  end

  def get_audit_postings
    Audit.find(:all,:select=>"audits.action,audits.created_at,employers.first_name,employers.last_name,roles.name as role_name",:joins=>"join employers on audits.user_id = employers.id join roles on employers.role_id = roles.id",:conditions=>["auditable_id = ? and auditable_type = 'Job' and user_type = 'Employer'",self.id])
  end

  def self.top_opportunities(job_seeker_id, optional, sort = "fit", order ="desc")
    # Changes for Pairing Logic
	  order_new = sorting_dashboard(sort, order)
	  #list = find(:all,:select=>"jobs.*,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(' ', job_locations.street_one,job_locations.street_two, job_locations.city) as location_name",:joins=>"join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on employers.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})",:conditions=>["jobs.active = ? AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true, false],:order=>"pairing desc",:limit=>"0,7",:order=>order_new)
	  qry = "SELECT * FROM (SELECT jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,jobs.name as job_name,jobs.expire_at as jobs_expire_at,job_statuses.read as rd,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', zipcodes.city, zipcodes.state) as location_name FROM `jobs`
	  join job_locations on jobs.job_location_id = job_locations.id
	  join employers on jobs.employer_id = employers.id
	  join companies on jobs.company_id = companies.id
	  join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})
	  left join zipcodes on job_locations.zip_code = zipcodes.zip
	  left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})
	  WHERE (jobs.active = 1 AND jobs.deleted = 0 AND expire_at > '#{Job.current_date_mysql_format()}') ORDER BY pairing DESC LIMIT 0,7  ) as a
	  ORDER BY a.#{order_new}"
	  list = find_by_sql(qry)
	  # End
  end

  def self.sorting_dashboard(sort, order)
    if sort == "fit"
      order_new = "pairing #{order}"
    elsif sort == "company"
      order_new = "company_name #{order}"
    elsif sort == "position"
      order_new = "job_name #{order}"
    elsif sort == "location"
      order_new = "location_name #{order}"
    elsif sort == "remaining"
      order_new = "jobs_expire_at #{order}"
    elsif sort == "read"
      order_new = "rd #{order}"
    elsif sort == "status"
      order_new = "read #{order},considering #{order}, interested #{order}, wild_card #{order}"
    else
      order_new = "pairing #{order}"
    end
    order_new
  end

  def self.sorting(sort, order)
    if sort == "fit"
      order_new = "pairing #{order}"
    elsif sort == "company"
      order_new = "hiring_company_name #{order}"
    elsif sort == "position"
      order_new = "jobs.name #{order}"
    elsif sort == "location"
      order_new = "location_name #{order}"
    elsif sort == "remaining"
      order_new = "jobs.expire_at #{order}"
    elsif sort == "read"
      order_new = "job_statuses.read #{order}"
    elsif sort == "status"
      order_new = "job_statuses.read #{order}, job_statuses.considering #{order}, job_statuses.interested #{order}, job_statuses.wild_card #{order}"
    else
      order_new = "pairing #{order}"
    end
    order_new
  end

  def self.sorting_my_hilo(sort, order)
    if sort == "fit"
      order_new = "pairing #{order}"
    elsif sort == "company"
      order_new = "company_name #{order}"
    elsif sort == "position"
      order_new = "job_list.name #{order}"
    elsif sort == "location"
      order_new = "location_name #{order}"
    elsif sort == "remaining"
      order_new = "job_list.expire_at #{order}"
    elsif sort == "read"
      order_new = "job_list.read #{order}"
    elsif sort == "status"
      order_new = "job_list.read #{order}, job_list.considering #{order}, job_list.interested #{order}, job_list.wild_card #{order}"
    else
      order_new = "pairing #{order}"
    end
    order_new
  end

  def fit_name_by_pairing
    # Changed for Pairing Logic
    if pairing > 4
      return "Best"
    elsif pairing > 3 and pairing <= 4
      return "Better"
    elsif pairing > 2 and pairing <= 3
      return "Good"
    else
      return "Wildcard"
    end
    #End
  end

  def fit_name_by_marks
    return true
  end

  def self.get_job_status(jobs, job_seeker_id)
    status_hash = {}
    for job in jobs
      job_status = JobStatus.where("job_id = ? and job_seeker_id = ?",job.id,job_seeker_id).last
      if not job_status.blank?
        status_hash.update({"#{job.id}" =>{:read_flag=>job_status.read,:considering=>job_status.considering,:interested => job_status.interested,:wild_card => job_status.wild_card,:follow=>job_status.follow}})
      end
    end
    return status_hash
  end

  def self.job_feed(company_id)
    select("jobs.*, CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id").where("active = ? AND deleted = ? AND internal = ? AND expire_at > ? AND company_id = ?", true, false, false, Job.current_date_mysql_format(), company_id).order("expire_at DESC").all
  end

  def self.all_active_posts(job_seeker_id,ics_type_id,js_company_id,for_count,limit=10,start=0,sort = "fit",order = "desc")
    order_new = sorting(sort, order)
    if ics_type_id == 4 #global
      if for_count
        list = select("jobs.*,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(' ', job_locations.street_one,job_locations.street_two, job_locations.city) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.internal = ? AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false,false).all
      else
        list = select("jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.internal = ? AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false,false).order(order_new).limit("#{start},#{limit}").all
      end
    else #internal
      if for_count
        list = select("jobs.*,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(' ', job_locations.street_one,job_locations.street_two, job_locations.city) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.company_id IN (#{Company.where(:id=>js_company_id).first.subtree_ids.join(',')}) AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false).all
      else
        list = select("jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.company_id IN (#{Company.where(:id=>js_company_id).first.subtree_ids.join(',')}) AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false).order(order_new).limit("#{start},#{limit}").all
      end
    end
  end

  def self.sort_by(sort,order)
    if sort == "fit"
      ord = "pairing "+order
    elsif sort == "company"
      ord = "company_name "+order
    elsif sort == "position"
      ord = "jobs.name "+order
    elsif sort == "location"
      ord = "location_name "+order
    elsif sort == "remaining"
      ord = "jobs.expire_at "+order
    end
    ord
  end

  def self.unread_jobs(job_seeker_id, for_count, page_num = 1 )
    rows = find_by_sql("Select jobs.* ,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(' ', job_locations.street_one,job_locations.street_two, job_locations.city) as location_name from jobs
            join job_locations on jobs.job_location_id = job_locations.id
            join employers on jobs.employer_id = employers.id
            join companies on jobs.company_id = companies.id
	    join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})where (jobs.active = 1 AND jobs.deleted = 0 AND  expire_at > '#{Job.current_date_mysql_format()}')  order by pairing desc, marks desc, jobs.id desc")
    job_statuses = JobStatus.find(:all,:conditions=>["job_seeker_id = ?",job_seeker_id])

    arr = []
    for row in rows
      exist_flag = false
      for js in job_statuses
        if row.id == js.job_id
          exist_flag = true
        end
      end

      if not exist_flag
        arr << row
      end
    end
    return arr
  end

  def self.following_jobs(job_seeker_id,ics_type_id,js_company_id,for_count,limit=10,start=0,sort = "fit",order = "desc")
    #ord = sort_by(sort,order)
    order_new = sorting(sort, order)

    qry = " Select jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name FROM jobs
 join employers on jobs.employer_id = employers.id
join companies on jobs.company_id = companies.id
left join job_locations on jobs.job_location_id = job_locations.id
join job_seeker_follow_companies on job_seeker_follow_companies.company_id = companies.id
join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})
left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})
where job_seeker_follow_companies.job_seeker_id = #{job_seeker_id}  AND (jobs.active = 1 AND jobs.deleted = 0 AND expire_at > '#{Job.current_date_mysql_format()}'"
    if ics_type_id == 4
      qry<<" AND jobs.internal = #{false})"
    else
      qry<<" AND jobs.company_id IN (#{Company.where(:id=>js_company_id).first.subtree_ids.join(',')}))"
    end
    qry << "ORDER BY #{order_new}"
    if not for_count
      #start_point = Job.table_row_start_index(page_num)
      qry << " LIMIT #{start},#{limit}"
    end
    list = find_by_sql(qry)
  end

  def self.history_jobs(job_seeker_id,ics_type_id,js_company_id,for_count,limit=10,start=0,sort = "fit",order = "desc")
    order_new = sorting(sort, order)
    if ics_type_id == 4
      if for_count
        list = select("jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.internal = ? AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false,false).all
      else
        list = select("jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.internal = ? AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false,false).order(order_new).limit("#{start},#{limit}").all
      end
    else
      if for_count
        list = select("jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.company_id IN (#{Company.where(:id=>js_company_id).first.subtree_ids.join(',')}) AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false).all
      else
        list = select("jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name").joins("left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.company_id IN (#{Company.where(:id=>js_company_id).first.subtree_ids.join(',')}) AND jobs.deleted = ? AND expire_at > '#{Job.current_date_mysql_format()}'",true,false).order(order_new).limit("#{start},#{limit}").all
      end
    end
  end

  def self.watchlist_jobs(job_seeker_id,ics_type_id,js_company_id,for_count,limit=10,start=0,sort = "fit",order = "desc")
    #ord = sort_by(sort,order)
    order_new = sorting(sort, order)

    qry = " Select jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name FROM jobs
 join employers on jobs.employer_id = employers.id
join companies on jobs.company_id = companies.id
left join job_locations on jobs.job_location_id = job_locations.id
join job_seeker_watchlists on job_seeker_watchlists.job_id = jobs.id
join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})
left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})
where job_seeker_watchlists.job_seeker_id = #{job_seeker_id} AND (jobs.active = 1 AND jobs.deleted = 0 AND expire_at > '#{Job.current_date_mysql_format()}'"
    if ics_type_id == 4
      qry<<" AND jobs.internal = #{false})"
    else
      qry<<" AND jobs.company_id IN (#{Company.where(:id=>js_company_id).first.subtree_ids.join(',')}))"
    end
    qry << "ORDER BY #{order_new}"
    if not for_count
      #start_point = Job.table_row_start_index(page_num)
      qry << " LIMIT #{start},#{limit}"
    end
    list = find_by_sql(qry)

  end

  def self.considering_jobs(job_seeker_id,for_count,limit=10,start=0,sort = "fit",order = "desc")
    #ord = sort_by(sort,order)
    order_new = sorting_my_hilo(sort, order)

    qry = " Select distinct  *from (SELECT jobs.*,job_statuses.read,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', zipcodes.city, zipcodes.state) as location_name, job_statuses.considering as considering,job_statuses.interested as interested, job_statuses.wild_card as wild_card, job_statuses.job_seeker_id as status_job_seeker_id FROM  jobs
      join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id
      join companies on jobs.company_id = companies.id
      join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})
      left join zipcodes on job_locations.zip_code = zipcodes.zip
      left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})
      ) as job_list
      where (considering IS NOT NULL AND considering = 1 AND interested IS NULL AND wild_card IS NULL AND status_job_seeker_id = #{job_seeker_id} ) AND (job_list.active = 1 AND job_list.deleted = 0 AND expire_at > '#{Job.current_date_mysql_format()}')"
    qry << "ORDER BY #{order_new}"
    if not for_count
      #start_point = Job.table_row_start_index(page_num)
      qry << " LIMIT #{start},#{limit}"
    end
    list = find_by_sql(qry)
  end

  def self.archived_jobs(job_seeker_id, for_count, page_num = 1, sort = "fit",order = "desc" )
    ord = sort_by(sort,order)
    qry = " Select * from (SELECT jobs.*,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(' ', job_locations.street_one,job_locations.street_two, job_locations.city) as location_name, job_statuses.archived as archived,job_statuses.job_seeker_id as status_job_seeker_id FROM  jobs
  join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id
  join companies on jobs.company_id = companies.id left join job_statuses on jobs.id = job_statuses.job_id
      join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) ORDER BY "+ord+") as job_list where (archived IS NOT NULL AND archived = 1 AND status_job_seeker_id = #{job_seeker_id} ) AND (job_list.active = 1 AND job_list.deleted = 0 AND expire_at > '#{Job.current_date_mysql_format()}')"
    if not for_count
      start_point = Job.table_row_start_index(page_num)
      qry << "  LIMIT #{start_point},#{SEEKER_ACCOUNT_JOBS_PER_PAGE}"
    end
    find_by_sql(qry)
  end

  def self.interested_jobs(job_seeker_id,for_count,limit=10,start=0,sort = "fit",order = "desc")
    order_new = sorting_my_hilo(sort, order)
    qry = " Select * from (SELECT jobs.*,job_statuses.read,job_statuses.considering,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', zipcodes.city, zipcodes.state) as location_name, job_statuses.interested as interested,job_statuses.wild_card as wild_card,job_statuses.job_seeker_id as status_job_seeker_id FROM  jobs
  join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id
  join companies on jobs.company_id = companies.id
     join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})
     left join zipcodes on job_locations.zip_code = zipcodes.zip
     left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})
     ) as job_list

       where ( ( (interested IS NOT NULL AND interested = 1) or (wild_card IS NOT NULL AND wild_card = 1) ) AND status_job_seeker_id = #{job_seeker_id}) AND (job_list.active = 1 AND job_list.deleted = 0 AND expire_at > '#{Job.current_date_mysql_format()}')"
    qry << "ORDER BY #{order_new}"
    if not for_count
      #start_point = Job.table_row_start_index(page_num)
      qry << " LIMIT #{start},#{limit}"
    end
    list = find_by_sql(qry)
  end

  def self.wild_card_jobs(job_seeker_id,for_count,limit=10,start=0,sort = "fit",order = "desc")
    #ord = sort_by(sort,order)
    qry = " Select * from (SELECT jobs.*,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(' ', job_locations.street_one,job_locations.street_two, job_locations.city) as location_name, job_statuses.wild_card as wild_card,job_statuses.job_seeker_id as status_job_seeker_id FROM  jobs
    join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id
    join companies on jobs.company_id = companies.id left join job_statuses on jobs.id = job_statuses.job_id
        join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})) as job_list
        where (wild_card IS NOT NULL AND wild_card = 1 AND status_job_seeker_id = #{job_seeker_id}) AND (job_list.active = 1 AND job_list.deleted = 0 AND expire_at > '#{Job.current_date_mysql_format()}')"

    if not for_count
      #start_point = Job.table_row_start_index(page_num)
      qry << " LIMIT #{start},#{limit}"
    end
    list = find_by_sql(qry)
    list = sorting(list, sort, order)
  end


  def self.expired_jobs(job_seeker_id, for_count, page_num = 1 )
    select_str = "jobs.*,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(' ', job_locations.street_one,job_locations.street_two, job_locations.city) as location_name"
    if not for_count
      start_point = Job.table_row_start_index(page_num)
      find(:all,:select=>select_str,:joins=>"join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})",:conditions=>["jobs.active = ? AND jobs.deleted = ? AND expire_at < ?",true,false,Time.now],:order=>"pairing desc, marks desc, jobs.id desc" ,:limit => "#{start_point}, #{SEEKER_ACCOUNT_JOBS_PER_PAGE}")
    else
      find(:all,:select=>select_str ,:joins=>"join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})",:conditions=>["jobs.active = ? AND jobs.deleted = ? AND expire_at < ?", true,false,Time.now],:order=>"pairing desc, marks desc, jobs.id desc" )
    end
  end

  def self.employer_viewed_jobs(job_seeker_id,ics_type_id,js_company_id,for_count,limit=10,start=0,sort = "fit",order = "desc")
    order_new = sorting(sort, order)
    time_diff = PURCHASED_PROFILE_VALIDITY.to_i * 24 * 60 * 60
    select_str = "jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(' ', job_locations.street_one,job_locations.street_two, job_locations.city) as location_name, purchased_profiles.created_at as purchased_on"

    if ics_type_id == 4
      if not for_count
        #start_point = Job.table_row_start_index(page_num)
        list = select(select_str).joins("join purchased_profiles on jobs.id = purchased_profiles.job_id left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.internal = ? AND jobs.deleted = ? AND purchased_profiles.job_seeker_id = ? AND TIME_TO_SEC(TIMEDIFF(?,purchased_profiles.created_at))  BETWEEN 1 and #{time_diff}  AND expire_at > ?",true,false,false,job_seeker_id, Time.now.utc, Time.now.utc).limit("#{start},#{limit}").order(order_new).all
      else
        list = select(select_str).joins("join purchased_profiles on jobs.id = purchased_profiles.job_id left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.internal = ? AND jobs.deleted = ? AND purchased_profiles.job_seeker_id = ? AND TIME_TO_SEC(TIMEDIFF(?,purchased_profiles.created_at)) BETWEEN 1 and #{time_diff}  AND expire_at > ?",true,false,false,job_seeker_id, Time.now.utc,Time.now.utc).all
      end
    else
      if not for_count
        #start_point = Job.table_row_start_index(page_num)
        list = select(select_str).joins("join purchased_profiles on jobs.id = purchased_profiles.job_id left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.company_id IN (#{Company.where(:id=>js_company_id).first.subtree_ids.join(',')}) AND jobs.deleted = ? AND purchased_profiles.job_seeker_id = ? AND TIME_TO_SEC(TIMEDIFF(?,purchased_profiles.created_at))  BETWEEN 1 and #{time_diff}  AND expire_at > ?",true,false,job_seeker_id, Time.now.utc, Time.now.utc).limit("#{start},#{limit}").order(order_new).all
      else
        list = select(select_str).joins("join purchased_profiles on jobs.id = purchased_profiles.job_id left join job_locations on jobs.job_location_id = job_locations.id join employers on jobs.employer_id = employers.id join companies on jobs.company_id = companies.id join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id}) left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})").where("jobs.active = ? AND jobs.company_id IN (#{Company.where(:id=>js_company_id).first.subtree_ids.join(',')}) AND jobs.deleted = ? AND purchased_profiles.job_seeker_id = ? AND TIME_TO_SEC(TIMEDIFF(?,purchased_profiles.created_at)) BETWEEN 1 and #{time_diff}  AND expire_at > ?",true,false,job_seeker_id, Time.now.utc,Time.now.utc).all
      end
    end

    order_new = sorting(sort, order)

    qry = "Select DISTINCT jobs.*,job_statuses.read,job_statuses.considering,job_statuses.interested,job_statuses.wild_card,pairing_logics.pairing_value as pairing,companies.name as company_name,CONCAT_WS(', ', job_locations.city, job_locations.state) as location_name FROM jobs
		  join employers on jobs.employer_id = employers.id
		  join companies on jobs.company_id = companies.id
		  join purchased_profiles on (purchased_profiles.job_id = jobs.id and purchased_profiles.job_seeker_id=#{job_seeker_id})
		  left join job_locations on jobs.job_location_id = job_locations.id
		  join pairing_logics on (pairing_logics.job_id = jobs.id and pairing_logics.job_seeker_id=#{job_seeker_id})
		  left join job_statuses on (job_statuses.job_id = jobs.id and job_statuses.job_seeker_id=#{job_seeker_id})
		  WHERE (jobs.active = 1 AND jobs.deleted_at IS NULL AND jobs.deleted = 0 AND expire_at > '#{Job.current_date_mysql_format()}')"

    qry << "ORDER BY #{order_new}"

    if not for_count
      #start_point = Job.table_row_start_index(page_num)
      qry << " LIMIT #{start},#{limit}"
    end
    list = find_by_sql(qry)
  end

  def job_status_for_seeker(job_seeker_id)
    JobStatus.where("job_seeker_id = ? and job_id = ?",job_seeker_id,self.id).last
  end

  def company_for_job
    Company.select("companies.*").where("jobs.id = ?",self.id).joins("join jobs on companies.id = jobs.company_id").first
  end


  def add_responsibilities(resp_arr)
    flag = false
    JobProfileResponsibility.delete_all(:job_id => self.id)
    for item in resp_arr
      if not item.blank?
        _ps_obj = ProfileResponsibility.create_or_get_responsibility(item)
        self.profile_responsibilities << _ps_obj
        flag = true
      end
    end
    return flag
  end

  def has_not_expired?
    return (expire_at > DateTime.now ? true : false)
  end

  def is_active?
    return (active == true ? true : false)
  end

  def self.cron_generate_notification_for_expired_positions
    jobs = Job.where(:active=>true).all
    #    jobs = Job.find_by_sql("select * from jobs join companies on jobs.company_id = companies.id where companies.ancestry is null and jobs.deleted_at is null and jobs.active = 1")
    for job in jobs
      remaining_days = (job.expire_at.to_time - Time.now.utc)/(24*60*60)
      remaining_days = remaining_days.days
      remaining_hours = remaining_days/1.hour
      if remaining_hours <= 48
        create_notification = true
        alerts = EmployerAlert.where(:job_id=>job.id).all
        for alert in alerts
          if alert.purpose == "expiry"
            create_notification = false
          end
        end
        if create_notification == true
          employer_alerts = EmployerAlert.create(:job_id=>job.id, :purpose=>"expiry", :read=>false, :employer_id=>job.employer_id)
          #alert method
          employer = job.employer
          if employer.alert_method == ON_EVENT_EMAIL and !employer.request_deleted
            email_hash = {:employer_first_name => employer.first_name, :employer_email => employer.email, :employer_alerts => employer_alerts.id}
            # alert = EmployerAlert.select("*").joins("join jobs on jobs.id = employer_alerts.job_id").where("employer_alerts.id = ?", employer_alerts.id)
            Notifier.email_employer_notifications(email_hash).deliver
            employer.notification_email_time = DateTime.now
            employer.save(:validate => false)
          end
        end
      end
      if remaining_hours <= 0
        job_seeker_ids = JobStatus.select("job_seeker_id, employers.company_id as comp_id").joins("join jobs on jobs.id = job_statuses.job_id join employers on employers.id = jobs.employer_id").where("job_id = #{job.id} and (interested = 1 or wild_card = 1)")
        job_seeker_ids.each{|j|
          if job.active == true
            alert = JobSeekerNotification.create(:job_seeker_id => j.job_seeker_id, :job_id => job.id, :notification_type_id => 3, :notification_message_id => 13, :visibility => true, :company_id => j.comp_id)
            job_seeker = JobSeeker.where(:id => j.job_seeker_id).first
            if job_seeker.alert_method == ON_EVENT_EMAIL and !job_seeker.request_deleted
              Notifier.email_job_seeker_notifications(job_seeker, alert).deliver
              job_seeker.notification_email_time = DateTime.now
              job_seeker.save(:validate => false)
            end
          end
        }
        posting_record = Posting.where("job_id = ?", job.id).first
        #JobSeeker feed
        job_ids = Array.new
        job_ids<<job.id
        if job.active
          if job.internal
            js_ids = JobSeeker.where(:company_id => job.company.path_ids, :activated => true).map{|js| js.id}
            job.company.path_ids.each do |c|
              BroadcastController.new.delay(:priority => 6).opportunities_internal(c, js_ids)
            end
            BroadcastController.new.employer_update(job.company_id, "xref", [job.id], js_ids)
          else
            job.company.path_ids.each do |c|
              BroadcastController.new.delay(:priority => 6).opportunities_internal(c, JobSeeker.where(:company_id => job.company.path_ids, :activated => true).map{|js| js.id})
            end
            BroadcastController.new.delay(:priority => 6).opportunities_normal(JobSeeker.where(:company_id=>nil, :activated => true).map{|js| js.id})
            js_ids = JobSeeker.where("company_id IN (#{job.company.path_ids.join(',')}) OR company_id IS NULL AND activated = #{true}").map{|js| js.id}
            BroadcastController.new.employer_update(job.company_id, "xref", [job.id], js_ids)
          end
        end
        #
        job.active = false
        job.internal = false
        posting_record.hilo_share = false
        posting_record.save(:validate => false)
        job.save(:validate => false)
        BroadcastController.new.delay(:priority => 6).send_feed(job.company_id)
      end
      #Code to activate job globally for Right associated companies.
      if job.company.parent_id == RIGHT_COMPANY_ID
        posting_record_update = Posting.where("job_id = ?", job.id).first
        remaining_days = (job.expire_at.to_time - Time.now.utc)/(24*60*60)
        remaining_days = remaining_days.days
        #        remaining_hours = remaining_days/1.hour
        if remaining_days <= 46.days
          #yellow to green
          js_ids = JobSeeker.where(:company_id => nil, :activated => true).map{|js| js.id}

          BroadcastController.new.delay(:priority => 6).opportunities_normal(JobSeeker.where(:company_id => nil, :activated => true).map{|js| js.id})
          BroadcastController.new.employer_update(job.company_id, "xref", [job.id], js_ids)
          BroadcastController.new.employer_update(job.company_id, "candidate_pool", [job.id])

          job.active = true
          job.internal = false
          job.expire_at = Time.now + (60 * 24 * 60 * 60)
          job.save!(:validate=>false)

          if not posting_record_update.nil?
            posting_record_update.hilo_share = true
            posting_record_update.save
          end
          #generate_alerts_for_sub_ordinate("job-active", job)
          PairingLogic.delay.pairing_value_job(job, "from_channel_manager")
        end
      end
    end
  end

  private

#  def document_attachment
#    job_attachments.map do |j|
#      if Rails.env == "production"
#        URI.parse("https://thehiloproject.com/"+j.attachment.url)
#      elsif Rails.env == "staging"
#        URI.parse("http://staging.thehiloproject.com/"+j.attachment.url)
#      else
#        URI.parse("http://localhost:3000"+j.attachment.url)
#      end
#    end
#  end

  def self.current_date_mysql_format
    Time.now.utc.strftime("%Y/%m/%d %H:%M:%S")
  end

  def self.table_row_start_index(page_num)
    return (page_num.to_i - 1) * 10
  end
end