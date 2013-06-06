class AddOrderToJobCriteriaCertificates < ActiveRecord::Migration
  def change
    add_column :job_criteria_certificates, :order, :integer
  end
end
