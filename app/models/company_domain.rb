require 'email_veracity'

class CompanyDomain < ActiveRecord::Base
  attr_accessible :company_id, :domain
  #attr_reader :errors
  belongs_to :company
  audited
  validates_uniqueness_of :domain
  #validate :check_domain_existence
  
  def self.create_domain(company_id, domain_names)
    flag = true
    dom = nil
    cntxt = ""
    CompanyDomain.delete_all(:company_id => company_id)
    domain_names.split(",").each do |dn|
      dn = dn.delete("@").strip
      logger.info "**********************************#{dn}"
      if CompanyDomain.check_domain("abc@"+dn).valid? #and CompanyDomain.find_by_domain(dn).nil?
        
          cd = CompanyDomain.create(:company_id => company_id, :domain => dn)
          if cd.errors.size > 0
            logger.info "*********************************rescue"
            #CompanyDomain.destroy_all(:company_id => company_id)
            flag = false
            dom = dn
            cntxt = "already exists"
            break
          end
        
      else
        logger.info "validation failure"
        #CompanyDomain.destroy_all(:company_id => company_id)
        flag = false
        dom = dn
        cntxt = "illegal format"
        break
      end
    end
    return flag, cntxt, dom
  end

  def self.check_domain(email)
    address = EmailVeracity::Address.new(email)
  end

  def check_domain_existence
    cd = CompanyDomain.find_by_domain(domain)
    unless cd.nil?
      if cd.company_id != company_id
        errors.add(:base, "Domain already exists")
      end
    end
  end

end
