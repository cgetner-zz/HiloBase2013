# coding: UTF-8

#require 'RMagick

require 'open-uri'
include ActionView::Helpers::SanitizeHelper
class JobSeeker < ActiveRecord::Base
  
  acts_as_paranoid
  attr_accessible :id, :first_name, :last_name, :email, :password, :password_confirmation, :city, :terms_of_service, :name, :created_by, :activated, :photo, :resume ,:hashed_password,:fpwd_code, :track_shared_job_id, :password_reset, :deleted, :request_deleted, :track_platform_id, :track_shared_company_id, :bridge_response, :random_token, :internal_candidate
  attr_accessor :random_token, :internal_candidate
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  validates :password,:on=>:create, :presence => true
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :email,:message=> "Email is already taken",:case_sensitive => false
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:message=>"Email is not valid", :if => :email?
  validates_format_of :contact_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:message=>"Contact email is not valid", :if => :contact_email?
  validates_confirmation_of :password,:if => Proc.new { |job_seeker| !job_seeker.password.blank? },:message=>"Confirm Password do not match"
  #validates_format_of :password,:with=>/^(?=.*\d).{6,15}$/,:message=>"Password should be atleast 6 characters and contain atleast 1 number",:if => Proc.new { |job_seeker| !job_seeker.password.blank? }
  validates_acceptance_of :terms_of_service,:message=>"Please check I agree to accept terms and conditions"
  validate :validate_job_seeker_photo
  validate :validate_job_seeker_url
  validate :validate_unique_email
  
  def validate_unique_email
    if not self.email.blank?
      employer = Employer.find(:first,:conditions=>["LOWER(email) like ? and deleted = ?",self.email.downcase, false])
      if not employer.blank?
        errors.add("email","Email is already taken")
      end
    end
  end

  has_many :career_seeker_saved_searches, :dependent=>:destroy
  has_many :payments
  has_many :purchased_profiles, :dependent => :destroy
  has_many :birkman_job_interest_responses, :dependent => :destroy
  has_many :birkman_question_responses, :dependent => :destroy
  has_many :job_seeker_workenv_questions, :dependent => :destroy
  has_many :log_job_shares
  has_many :job_seeker_desired_employments,:dependent=>:destroy
  has_many :desired_employments,:through=>:job_seeker_desired_employments
      
  has_many :job_seeker_desired_locations,:dependent=>:destroy
  has_many :desired_locations,:through => :job_seeker_desired_locations
	  
  has_many :added_degrees, :foreign_key => "adder_id", :dependent => :destroy, :conditions => "added_degrees.adder_type = 'JobSeeker'"
  has_many :degrees, :through => :added_degrees, :conditions => "added_degrees.adder_type = 'JobSeeker'"
      
  has_many :job_seeker_certificates,:dependent=>:destroy
  has_many :new_certificates, :through=>:job_seeker_certificates
  has_many :licenses, :through=>:job_seeker_certificates
      
  has_many :job_seeker_languages,:dependent=>:destroy
  has_many :languages,:through =>:job_seeker_languages

  has_many :added_universities, :foreign_key => "adder_id", :dependent => :destroy, :conditions => "added_universities.adder_type = 'JobSeeker'"
  has_many :universities, :through => :added_universities, :conditions => "added_universities.adder_type = 'JobSeeker'"

  has_one :credit, :dependent => :destroy
  belongs_to :ics_type
  belongs_to :company

  has_many :added_roles, :foreign_key => "adder_id", :dependent => :destroy, :conditions => "added_roles.adder_type = 'JobSeeker'"
  has_many :occupation_data, :foreign_key => "adder_id", :through => :added_roles, :conditions => "added_roles.adder_type = 'JobSeeker'"

  has_one :job_seeker_birkman_detail,:dependent=>:destroy
  has_many :pairing_logics, :dependent=>:destroy
  has_many :job_seeker_notifications, :dependent => :destroy

  has_many :job_seeker_follow_companies, :dependent=>:destroy
  has_many :job_seeker_watchlists, :dependent=>:destroy

  has_many :job_statuses, :dependent=>:destroy

  before_destroy :update_deleted
  after_save :linkedin_public_data_import
  
  def update_deleted
    Notifier.delete_seeker(self).deliver
    if self.resume_file_name
      FileUtils.remove_dir(File.expand_path(File.dirname(self.resume.path)), force = true)
    end
    if self.photo_file_name
      FileUtils.remove_dir(File.expand_path(File.dirname(self.photo.path)), force = true)
    end
    self.deleted = true
    self.request_deleted = false
    self.save(:validate=>false)
  end

  # FOR PHOTO
  # For over-riding paperclip save folder, for photos

  #TODO : uncomment for paperclip
  has_attached_file :photo,
    :url    => "/system/photos/:id/:style/:basename.:extension",
    :path   => "#{Rails.root}/public/system/photos/:id/:style/:basename.:extension",
    :styles => { :thumb=> "110x110" }
  validates_attachment_size :photo, :less_than => 1.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/pjpeg']

  # FOR RESUME
  # For over-riding paperclip save folder, for resume
  has_attached_file :resume,
    :url  => "/system/resume/:id/:basename.:extension",
    :path => "#{Rails.root}/public/system/resume/:id/:basename.:extension"
  validates_attachment_size :resume, :less_than => 1.megabytes
  validates_attachment_content_type :resume, :content_type => ['application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/msword']

  #TODO  : uncomment for paperclip end

  searchable :auto_index => false do
    text :desired_employments do |job_seeker|
      job_seeker.desired_employments.map {|desired_employment| desired_employment.name}
    end

    text :job_seeker_desired_location_city do
      job_seeker_desired_locations.map {|job_seeker_desired_location| job_seeker_desired_location.city}
    end

    text :degrees do |job_seeker|
      job_seeker.degrees.map {|degree| degree.name}
    end

    text :new_certificates do |job_seeker|
      job_seeker.new_certificates.map {|new_certificate| new_certificate.certification_name}
    end

    text :licenses do |job_seeker|
      job_seeker.licenses.map {|license| license.license_name}
    end

    text :languages do |job_seeker|
      job_seeker.languages.map {|language| language.name}
    end

    text :universities do |job_seeker|
      job_seeker.universities.map {|university| university.institution}
    end

    text :summary

    text :roles do |job_seeker|
      job_seeker.occupation_data.map {|od| od.title}
    end

    text :linkedin_crawl_data
      
    attachment :document_attachment
  end
  
  #before_save :set_default_contact_email,:save_default_preferred_contact
  
  ##RSPEC: Can't be tested
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

  def self.cron_reset_password
    job_seekers = JobSeeker.where(:ics_type_id => 3, :request_deleted => false).all
    job_seekers.each do |js|
      if js.last_login
        if (DateTime.now.utc - js.last_login.to_date).to_i >= 45
          #js.update_attribute(:hashed_password, JobSeeker.encrypted_password(JobSeeker.generate_random_password))
          js.update_attribute(:password_reset, false)
          fpwd_code = Digest::SHA1.hexdigest(Time.now.to_i.to_s)
          js.update_attribute(:fpwd_code, fpwd_code)
          #send mail
          Notifier.password_reset(js.email,js.first_name,js.last_name,fpwd_code).deliver
        end
      end
    end
  end

  def self.generate_random_password
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    str  =  (0..5).map{ o[rand(o.length)]  }.join
    str
  end
      
  ##RSPEC: Can't be tested
  def validate_job_seeker_url
    if not self.video_url .blank?
      if not self.video_url.match(/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix)
        errors.add("URL","Invalid URL")
      end
    end
  end
  ##RSPEC: Can't be tested
  def validate_job_seeker_photo
    if not self.photo_file_name .blank?
      if not self.photo_content_type.match(/image|png|jpg|jpeg|gif/)
        errors.add("Photo","Only image file allowed")
      end
    end
  end
      
  def full_name
    self.first_name.humanize + " " + self.last_name.humanize
  end
  ##RSPEC: Can't be tested
  def save_previous_id(previous_taken_id)
    _job_seeker_birkman_detail = self.job_seeker_birkman_detail
    if _job_seeker_birkman_detail.blank?
      _job_seeker_birkman_detail = JobSeekerBirkmanDetail.new({:job_seeker_id => self.id})
    end
    _job_seeker_birkman_detail.unique_identifier = previous_taken_id.strip
    _job_seeker_birkman_detail.birkman_user_id=previous_taken_id.strip
    _job_seeker_birkman_detail.test_complete = true
    _job_seeker_birkman_detail.save(:validate => false)
  end
     
  ##RSPEC: Can't be tested
  def add_languages(lang_hash)
    JobSeekerLanguage.delete_all("job_seeker_id = '#{self.id}'")
    lang_hash.each{|k,v|
      begin
        lang = Language.find(k)
        self.job_seeker_languages << JobSeekerLanguage.new({:language_id => k,:proficiency_val => v})
      rescue ActiveRecord::RecordNotFound
      end
    }
  end
  ##RSPEC: Can't be tested
  def add_languages_new(lang_hash)
    JobSeekerLanguage.delete_all("job_seeker_id = '#{self.id}'")
    if !lang_hash.blank?
      lang_arr = lang_hash.split(",")
      lang_arr.each{|lang|
        lang_each = lang.split("__")
        lang_id = Language.find_by_name(lang_each[0]).id
        begin
          self.job_seeker_languages << JobSeekerLanguage.new({:language_id => lang_id, :proficiency_val => lang_each[1]})
        rescue ActiveRecord::RecordNotFound
        end
      }
    end
  end
  ##RSPEC: Can't be tested
  def add_proficiencies(prof_names,created_by_id)
    JobSeekerProficiency.delete_all("job_seeker_id = '#{self.id}'")
    for prof in prof_names
      prof_obj  = Proficiency.find_by_name(prof.strip)
      if prof_obj.nil?
        prof_obj = Proficiency.new({:name=>prof,:created_by=>created_by_id})
      end
      self.proficiencies << prof_obj
    end
  end
  ##RSPEC: Can't be tested
  def add_skills(skill_names,created_by_id)
    job_seeker = JobSeeker.find(created_by_id)
    JobSeekerProficiency.delete_all("job_seeker_id = '#{self.id}'")
          
    for skill in skill_names

      skill_split = skill.split("__");
      skill_obj = Proficiency.find_by_name(skill_split[0])
      if skill_obj.nil?
        skill_obj = Proficiency.create({:name=>skill_split[0],:created_by=>created_by_id,:activated=>"0"})
      end

      JobSeekerProficiency.create!(:job_seeker_id => created_by_id, :proficiency_id => skill_obj.id, :education_id => skill_split[1].split("_")[0], :skill_id => skill_split[2].split("_")[0])

    end
  end
  ##RSPEC: Can't be tested
  def add_certificates(cert_names,created_by_id)
    JobSeekerCertificate.delete_all("job_seeker_id = '#{self.id}'")
    for cert in cert_names
      cert_obj  = Certificate.find_by_name(cert.strip)
      if cert_obj.nil?
        cert_obj = Certificate.new({:name=>cert,:created_by=>created_by_id,:user_type=>"JobSeeker"})
      end
      self.certificates << cert_obj
    end
  end
  ##RSPEC: Can't be tested
  def is_following_company?(company_id)
    return (JobSeekerFollowCompany.find(:first,:conditions=>["job_seeker_id = ? and company_id = ?", self.id, company_id]).nil? ? false : true)
  end
  ##RSPEC: Can't be tested
  def job_is_in_watchlist?(job_id)
    return (JobSeekerWatchlist.find(:first, :conditions=>["job_seeker_id = ? and job_id = ?", self.id, job_id]).nil? ? false : true)
  end
      
  def password
    @password
  end
    
  def password=(pwd)
    @password = pwd
    self.hashed_password = JobSeeker.encrypted_password(@password)
  end
  ##RSPEC: Can't be tested
  def self.authenticate_job_seeker(login_name,login_pass)
    job_seeker = JobSeeker.where("email = ? and hashed_password = ? and email_verified = ? and password_reset = ? and request_deleted = 0 and deleted = 0" ,login_name,JobSeeker.encrypted_password(login_pass),true,true).first
  end
      
  def self.encrypted_password(pwd)
    Digest::SHA1.hexdigest(pwd)
  end

  def job_seeker_privilege
    if !self.track_shared_job_id.nil?
      a = Job.select("employer_privileges.credit_value, employer_privileges.discount_value").joins("join employers on jobs.employer_id = employers.id join employer_privileges on employers.company_id = employer_privileges.company_id").where("jobs.id = #{self.track_shared_job_id} and employer_privileges.status = 1").first
    end
    if !self.track_shared_company_id.nil?
      a = Company.select("employer_privileges.credit_value, employer_privileges.discount_value").joins("join employer_privileges on companies.id = employer_privileges.company_id").where("companies.id = #{self.track_shared_company_id} and employer_privileges.status = 1").first
    end
    return a
  end

  def job_seeker_created_privilege
    if !self.track_shared_job_id.nil?
      a = Job.select("employer_privileges.credit_value, employer_privileges.discount_value, companies.name as comp_name").joins("join employers on jobs.employer_id = employers.id join employer_privileges on employers.company_id = employer_privileges.company_id join companies on employer_privileges.company_id = companies.id").where("jobs.id = #{self.track_shared_job_id} and employer_privileges.status = 1").first
    end
    if !self.track_shared_company_id.nil?
      a = Company.select("employer_privileges.credit_value, employer_privileges.discount_value, companies.name as comp_name").joins("join employer_privileges on companies.id = employer_privileges.company_id").where("companies.id = #{self.track_shared_company_id} and employer_privileges.status = 1").first
    end
    return a
  end

  def job_seeker_activated_privilege
    if !self.track_shared_job_id.nil?
      a = ReferralFee.select("referral_fees.credit_amount, referral_fees.discount_amount").where("#{self.id} = referral_fees.job_seeker_id and #{self.track_shared_job_id} = referral_fees.job_id").first
    end
    if !self.track_shared_company_id.nil?
      a = ReferralFee.select("referral_fees.credit_amount, referral_fees.discount_amount").where("#{self.id} = referral_fees.job_seeker_id and #{self.track_shared_company_id} = referral_fees.company_id").first
    end
    return a
  end

  def self_delete
    begin
      #BirkmanJobInterestResponse.delete_all(:job_seeker_id => self.id)
      #BirkmanQuestionResponse.delete_all(:job_seeker_id => self.id)
      #JobSeekerWorkenvQuestion.delete_all(:job_seeker_id => self.id)
      #LogJobShare.delete_all(:job_seeker_id => self.id)
      flag = 1
      if self.ics_type_id != 4
        if self.company
          self.company.employers.each do |emp|
            ea = EmployerAlert.create(:job_id=>nil, :job_seeker_id=>self.id, :purpose=>"ics-deleted", :read=>false, :new=>true, :employer_id => emp.id, :deleted_employer_id => nil)
            if emp.alert_method == ON_EVENT_EMAIL  and !emp.request_deleted
              email_hash = {:employer_first_name => emp.first_name, :employer_email => emp.email, :employer_alerts => ea.id}
              Notifier.email_employer_notifications(email_hash).deliver
              emp.notification_email_time = DateTime.now
              emp.save(:validate => false)
            end
          end
          flag = 0
        end
      end
      if flag
        #PurchasedProfile.where(:job_seeker_id => self.id).map{|m| m.company.employers}.each do |emp|
        company_ids = []
        PurchasedProfile.where(:job_seeker_id => self.id).select{|m| m.company}.each do |comp|
          company_ids<<comp.company_id
        end
        company_ids.uniq.each do |c|
          Company.find_by_id(c).employers.each do |emp|
            ea = EmployerAlert.create(:job_id=>nil, :job_seeker_id=>self.id, :purpose=>"cs-purchased-deleted", :read=>false, :new=>true, :employer_id => emp.id, :deleted_employer_id => nil)
            if emp.alert_method == ON_EVENT_EMAIL  and !emp.request_deleted
              email_hash = {:employer_first_name => emp.first_name, :employer_email => emp.email, :employer_alerts => ea.id}
              Notifier.email_employer_notifications(email_hash).deliver
              emp.notification_email_time = DateTime.now
              emp.save(:validate => false)
            end
          end
        end
      end

      #feed
      #dashboard
      #      PurchasedProfile.where(:job_seeker_id => self.id).map{|p| p.job_id}.uniq.each do |j|
      #        emp = Job.find_by_id(j).employer
      #        BroadcastController.new.employer_dashboard(emp.id, -1)
      #        emp.ancestor_ids.each do |id|
      #          BroadcastController.new.employer_dashboard(id, -1)
      #        end
      #      end

      #changes (checked)
      PurchasedProfile.where(:job_seeker_id => self.id).map{|p| p.company_id}.uniq.each do |c|
        BroadcastController.new.employer_update(c, "dashboard", [], [self.id])
      end


      #candidate_pool
      if self.ics_type_id != 4
        #        BroadcastController.new.purchased_position(self.company_id, -1)

        self.company.subtree_ids.each do |c|
          BroadcastController.new.employer_update(c, "candidate_pool", Job.where(:company_id=>c))
        end
      else
        Company.all.each do |c|
          #          BroadcastController.new.purchased_position(c.id, -1)

          BroadcastController.new.employer_update(c, "candidate_pool", Job.where("company_id = ? AND internal = ?", c, false))
        end
      end
      #
      self.destroy
    rescue
      self.request_deleted = true
      self.save(:validate=>false)
    end
  end

  def self.is_deleted?(id)
    JobSeeker.find_by_id(id).nil?
  end

  def can_view?(job)
    if job.nil?
      return false
    end

    if [1,2,3].include? self.ics_type_id #internal
      if job.company.path_ids.include? self.company_id and job.active and !job.deleted
        return true
      else
        return false
      end
    else #normal
      if job.internal
        return false
      else
        return true
      end
    end
  end

  private

  def document_attachment
    if Rails.env == "production"
      URI.parse("https://thehiloproject.com/"+resume.url)
    elsif Rails.env == "staging"
      URI.parse("http://staging.thehiloproject.com/"+resume.url)
    else
      logger.info("***************Rails.env #{Rails.env}")
      URI.parse("http://localhost:3000"+resume.url)
    end
  end
  
  def linkedin_public_data_import
    website_hash = {}
    crawled_data = ''
    combining_crawled_data = ''
    website_hash.store("website_one", self.website_one)
    website_hash.store("website_two", self.website_two)
    website_hash.store("website_three", self.website_three)
    website_hash.delete_if { |k, v| v.nil? }
    website_hash.map { |k,v| v }.uniq.each { |link|
      if link.include? ".linkedin.com/pub/"
        crawled_data = pismo_crawl link
      end
      combining_crawled_data = combining_crawled_data + ' ' + crawled_data
    }
    
    unless combining_crawled_data.nil?
      self.update_column(:linkedin_crawl_data, combining_crawled_data)
    end
    
  end
  
  def pismo_crawl website_link = nil
    ignore_word_arr = ["a's", "able", "about", "above", "according", "accordingly", "across", "actually", "after", "afterwards", "again", "against", "ain't", "all", "allow", "allows", "almost", "alone", "along", "already", "also", "although", "always", "am", "among", "amongst", "an", "and", "another", "any", "anybody", "anyhow", "anyone", "anything", "anyway", "anyways", "anywhere", "apart", "appear", "appreciate", "appropriate", "are", "aren't", "around", "as", "aside", "ask", "asking", "associated", "at", "available", "away", "awfully", "be", "became", "because", "become", "becomes", "becoming", "been", "before", "beforehand", "behind", "being", "believe", "below", "beside", "besides", "best", "better", "between", "beyond", "both", "brief", "but", "by", "c'mon", "c's", "came", "can", "can't", "cannot", "cant", "cause", "causes", "certain", "certainly", "changes", "clearly", "co", "com", "come", "comes", "concerning", "consequently", "consider", "considering", "contain", "containing", "contains", "corresponding", "could", "couldn't", "course", "currently", "definitely", "described", "despite", "did", "didn't", "different", "do", "does", "doesn't", "doing", "don't", "done", "down", "downwards", "during", "each", "edu", "eg", "eight", "either", "else", "elsewhere", "enough", "entirely", "especially", "et", "etc", "even", "ever", "every", "everybody", "everyone", "everything", "everywhere", "ex", "exactly", "example", "except", "far", "few", "fifth", "first", "five", "followed", "following", "follows", "for", "former", "formerly", "forth", "four", "from", "further", "furthermore", "get", "gets", "getting", "given", "gives", "go", "goes", "going", "gone", "got", "gotten", "greetings", "had", "hadn't", "happens", "hardly", "has", "hasn't", "have", "haven't", "having", "he", "he's", "hello", "help", "hence", "her", "here", "here's", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "hi", "him", "himself", "his", "hither", "hopefully", "how", "howbeit", "however", "i'd", "i'll", "i'm", "i've", "ie", "if", "ignored", "immediate", "in", "inasmuch", "inc", "indeed", "indicate", "indicated", "indicates", "inner", "insofar", "instead", "into", "inward", "is", "isn't", "it", "it'd", "it'll", "it's", "its", "itself", "just", "keep", "keeps", "kept", "know", "knows", "known", "last", "lately", "later", "latter", "latterly", "least", "less", "lest", "let", "let's", "like", "liked", "likely", "little", "look", "looking", "looks", "ltd", "mainly", "many", "may", "maybe", "me", "mean", "meanwhile", "merely", "might", "more", "moreover", "most", "mostly", "much", "must", "my", "myself", "name", "namely", "nd", "near", "nearly", "necessary", "need", "needs", "neither", "never", "nevertheless", "new", "next", "nine", "no", "nobody", "non", "none", "noone", "nor", "normally", "not", "nothing", "novel", "now", "nowhere", "obviously", "of", "off", "often", "oh", "ok", "okay", "old", "on", "once", "one", "ones", "only", "onto", "or", "other", "others", "otherwise", "ought", "our", "ours", "ourselves", "out", "outside", "over", "overall", "own", "particular", "particularly", "per", "perhaps", "placed", "please", "plus", "possible", "presumably", "probably", "provides", "que", "quite", "qv", "rather", "rd", "re", "really", "reasonably", "regarding", "regardless", "regards", "relatively", "respectively", "right", "said", "same", "saw", "say", "saying", "says", "second", "secondly", "see", "seeing", "seem", "seemed", "seeming", "seems", "seen", "self", "selves", "sensible", "sent", "serious", "seriously", "seven", "several", "shall", "she", "should", "shouldn't", "since", "six", "so", "some", "somebody", "somehow", "someone", "something", "sometime", "sometimes", "somewhat", "somewhere", "soon", "sorry", "specified", "specify", "specifying", "still", "sub", "such", "sup", "sure", "t's", "take", "taken", "tell", "tends", "th", "than", "thank", "thanks", "thanx", "that", "that's", "thats", "the", "their", "theirs", "them", "themselves", "then", "thence", "there", "there's", "thereafter", "thereby", "therefore", "therein", "theres", "thereupon", "these", "they", "they'd", "they'll", "they're", "they've", "think", "third", "this", "thorough", "thoroughly", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "took", "toward", "towards", "tried", "tries", "truly", "try", "trying", "twice", "two", "un", "under", "unfortunately", "unless", "unlikely", "until", "unto", "up", "upon", "us", "use", "used", "useful", "uses", "using", "usually", "value", "various", "very", "via", "viz", "vs", "want", "wants", "was", "wasn't", "way", "we", "we'd", "we'll", "we're", "we've", "welcome", "well", "went", "were", "weren't", "what", "what's", "whatever", "when", "whence", "whenever", "where", "where's", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "who's", "whoever", "whole", "whom", "whose", "why", "will", "willing", "wish", "with", "within", "without", "won't", "wonder", "would", "would", "wouldn't", "yes", "yet", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves", "zero", "Join", "LinkedIn", 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','Copyright','Policy','Cookie','Privacy','Agreement','User','Corporation','prohibited.','©','members','Browse','members','country','By','site',"LinkedIn's",'Commercial','authorization','India','&amp;','»','2011','express','agree','terms','use','View','site,','use.','-','Full','Profile','Not','for?','directly','full','profile','Search','people', '200', 'million', 'professionals', 'LinkedIn.','Today','Sign','In',"As",'member','join','sharing','connections','ideas','opportunities.','And','free!',"You'll","to:",'See','common','Get','introduced','Connections','Overview','Name','Search:','First','Last','Example:']
    html = open(website_link)
    n_doc = Nokogiri::HTML(html)
    n_doc.css('script').remove
    n_doc_text = n_doc.to_s
    n_doc_text = n_doc_text.split("<body")[1]

    n_doc_text = "<body" + n_doc_text
    n_doc_text = strip_tags n_doc_text
    n_doc_text = n_doc_text.gsub("\n"," ").gsub("/*","").gsub("*/","")
    n_doc_text = n_doc_text.squeeze(' ')
    linked_in_data = n_doc_text.split.delete_if{|x| ignore_word_arr.include?(x)}.join(' ')
    linked_in_data = linked_in_data.split('Viewers viewed...')[0] #Split this because we were getting irrelevant data of Viewers of this profile also viewed...
    linked_in_data = linked_in_data.split(' ').uniq.join(' ')
    return linked_in_data
  end
  
end