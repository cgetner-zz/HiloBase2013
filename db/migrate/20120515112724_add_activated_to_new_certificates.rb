class AddActivatedToNewCertificates < ActiveRecord::Migration
  def up
    rename_table :New_Certificates, :new_certificates
    add_column :new_certificates, :activated, :boolean, :default=>true
  end
end
