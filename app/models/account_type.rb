class AccountType < ActiveRecord::Base
  attr_accessible :account_type
  has_many :employers
end
