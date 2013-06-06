class ChangeAgainColumnNamesCetificatesAndLicenses < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("ALTER TABLE new_certificates CHANGE `Occupation` `occupation` VARCHAR(255);")
    ActiveRecord::Base.connection.execute("ALTER TABLE new_certificates CHANGE `Sub-Occupation` `sub_occupation` VARCHAR(255);")
    ActiveRecord::Base.connection.execute("ALTER TABLE new_certificates CHANGE `Certifying Organization` `certifying_organization` VARCHAR(255);")
    ActiveRecord::Base.connection.execute("ALTER TABLE new_certificates CHANGE `Certification Description` `certification_description` TEXT;")
    ActiveRecord::Base.connection.execute("ALTER TABLE new_certificates CHANGE `Source URL` `source_url` VARCHAR(255);")

    ActiveRecord::Base.connection.execute("ALTER TABLE licenses CHANGE `Occupation` `occupation` VARCHAR(255);")
    ActiveRecord::Base.connection.execute("ALTER TABLE licenses CHANGE `Licensing Agency` `licensing_agency` VARCHAR(255);")
    ActiveRecord::Base.connection.execute("ALTER TABLE licenses CHANGE `State` `state` VARCHAR(255);")
    ActiveRecord::Base.connection.execute("ALTER TABLE licenses CHANGE `License Description` `license_description` TEXT;")
    ActiveRecord::Base.connection.execute("ALTER TABLE licenses CHANGE `Source URL` `source_url` VARCHAR(255);")
  end

  def down
  end
end
