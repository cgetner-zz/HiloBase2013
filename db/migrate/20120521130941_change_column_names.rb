class ChangeColumnNames < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("ALTER TABLE new_certificates CHANGE `Certification Name` `certification_name` VARCHAR(255) NOT NULL;")
    ActiveRecord::Base.connection.execute("ALTER TABLE licenses CHANGE `License Name` `license_name` VARCHAR(255) NOT NULL;")
    ActiveRecord::Base.connection.execute("ALTER TABLE new_certificates CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT;")
    ActiveRecord::Base.connection.execute("ALTER TABLE licenses CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT;")
  end

  def down
  end
end
