class EmployerPrivileges < ActiveRecord::Base
  attr_accessible :company_id, :status, :credit_value, :discount_value
end
