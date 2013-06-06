class CorporateAccount < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :company_name, :contact, :is_approved, :terms_of_service
  validates_presence_of :first_name, :last_name, :email, :company_name, :contact
  validates_acceptance_of :terms_of_service,:message=>"Please check I agree to accept terms and conditions"

  def full_name
    name = first_name + ' '
    name += last_name
  end
end
