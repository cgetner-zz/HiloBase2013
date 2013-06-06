# coding: UTF-8

class Company < ActiveRecord::Base
  
  audited
  acts_as_paranoid
  has_ancestry
  attr_accessible :name, :city, :state, :country, :random_token, :hilo_subscription
  
  validates :name, :presence=>true
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :name, :message=>"Company name already taken"
  #validates_format_of :website,:with=> /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,:allow_blank => true,:message=>"Invalid Website URL"
  validates_format_of :facebook_link,:with=> /^http(s)*:\/\/([a-z]+\.)*facebook\.com/,:allow_blank => true,:message=>"Invalid Facebook URL"
  validates_format_of :twitter_link,:with=> /^http(s)*:\/\/([a-z]+\.)*twitter\.com/,:allow_blank => true,:message=>"Invalid Twitter URL"
  validates_format_of :other_link_one,:with=> /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,:allow_blank => true,:message=>"Invalid Link 1 URL"
  validates_format_of :other_link_two,:with=> /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,:allow_blank => true,:message=>"Invalid Link 2 URL"
  
  has_many :company_domains, :dependent => :destroy
  has_many :company_postings, :dependent => :destroy
  has_many :job_seeker_follow_companies, :dependent => :destroy
  has_many :employers
  has_many :jobs
  has_many :purchased_profiles
  belongs_to :owner_ship_type
  has_many :employer_privileges, :dependent => :destroy
  has_many :job_seekers

  before_destroy :delete_ics_three_and_convert_rest

  def delete_ics_three_and_convert_rest
    self.job_seekers.each do |j|
      if j.ics_type_id == 3
        #Notifier.delete_seeker(j).deliver
        j.destroy
      else
        j.company_id = nil
        j.ics_type_id = 4
        j.bridge_response = nil
        j.track_shared_job_id = nil
        j.track_shared_company_id = nil
        j.track_platform_id = nil
        j.save!(:validate=>false)
        PairingLogic.pairing_value_job_seeker(j)
        Notifier.ics_convert(j).deliver
      end
    end
  end

  def self.fetch_random_token(company_id)
    company = Company.find(company_id)
    if company.random_token.nil?
      token = Company.encrypted_token(Company.generate_random_token)
      company.update_attribute(:random_token, token)
    else
      token = company.random_token
    end
    return token
  end

  def self.generate_random_token
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    str  =  (0..5).map{ o[rand(o.length)]  }.join
    str
  end

  def self.encrypted_token(token)
    Base64.encode64(token).delete("\n")
  end

  def self.set_random_token(company_id)
    company = Company.find(company_id)
    token = Company.encrypted_token(Company.generate_random_token)
    company.update_attribute(:random_token, token)
    return token
  end

  def verify_random_token(token)
    if token == Company.fetch_random_token(self.id)
      return true
    else
      return false
    end
  end
end
