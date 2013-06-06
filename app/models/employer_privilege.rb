class EmployerPrivilege < ActiveRecord::Base
  attr_accessible :company_id, :status, :credit_value, :discount_value
  belongs_to :company
  audited
end
