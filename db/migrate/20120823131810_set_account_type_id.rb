class SetAccountTypeId < ActiveRecord::Migration
  def up
    Employer.with_deleted.all.each {|e|
      e.account_type_id ||= 3
      e.save(:validate=>false)
    }
  end

  def down
  end
end
