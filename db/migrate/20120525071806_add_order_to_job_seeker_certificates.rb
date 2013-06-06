class AddOrderToJobSeekerCertificates < ActiveRecord::Migration
  def change
    add_column :job_seeker_certificates, :order, :integer
  end
end
