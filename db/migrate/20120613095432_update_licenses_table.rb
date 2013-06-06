class UpdateLicensesTable < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("ALTER TABLE licenses CHANGE `ID` `id` INT(11) NOT NULL AUTO_INCREMENT;")
    execute("truncate licenses")
    require 'csv'
    cmr_path = File.join(Rails.root, "public/csv_files/licenses.csv")
    CSV.foreach(cmr_path) do |row|
      License.create!(:id => row[0], :occupation => row[1], :license_name => row[2], :licensing_agency => row[3], :state => row[4], :license_description => row[5], :source_url => row[6], :activated => row[7])
    end
  end

  def down
    execute("truncate licenses")
  end
end
