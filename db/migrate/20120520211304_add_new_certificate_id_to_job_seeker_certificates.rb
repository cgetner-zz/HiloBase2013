class AddNewCertificateIdToJobSeekerCertificates < ActiveRecord::Migration
  def change
    add_column :job_seeker_certificates, :new_certificate_id, :integer
  end
end
