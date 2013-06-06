class AddAccountDeleteRequestIntoAccessLevels < ActiveRecord::Migration
  def self.up
    AccessLevel.create!(:name => "Account Delete Request")
  end

  def self.down
    AccessLevel.find_by_name("Account Delete Request").destroy
  end
end