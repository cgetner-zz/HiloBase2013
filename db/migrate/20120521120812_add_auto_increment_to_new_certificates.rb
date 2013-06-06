class AddAutoIncrementToNewCertificates < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute("ALTER TABLE `new_certificates` MODIFY COLUMN `ID` INT AUTO_INCREMENT")
  end
end
