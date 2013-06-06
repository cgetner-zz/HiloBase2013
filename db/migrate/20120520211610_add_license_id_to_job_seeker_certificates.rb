class AddLicenseIdToJobSeekerCertificates < ActiveRecord::Migration
  def change
    add_column :job_seeker_certificates, :license_id, :integer
  end
end
