class CredentialsChanges < ActiveRecord::Migration
  def up
    create_table :added_roles do |t|
      t.integer :adder_id
      t.string :adder_type     
      t.string :code, :default => false
      t.timestamps
    end
    
    create_table :added_universities do |t|
      t.integer :adder_id
      t.string :adder_type     
      t.integer :university_id
      t.timestamps
    end
    
    create_table :added_degrees do |t|
      t.integer :adder_id
      t.string :adder_type     
      t.integer :degree_id
      t.timestamps
    end
    
    add_column :job_criteria_certificates, :new_certificate_id, :integer
    add_column :job_criteria_certificates, :license_id, :integer
      
    add_column :job_seeker_certifications, :new_certificate_id, :integer
    add_column :job_seeker_certifications, :license_id, :integer
     
  end

  def down
    drop_table :added_roles
    drop_table :added_universities
    drop_table :added_degrees
    
    remove_column :job_criteria_certificates, :new_certificate_id
    remove_column :job_criteria_certificates, :license_id
      
    remove_column :job_seeker_certifications, :new_certificate_id
    remove_column :job_seeker_certifications, :license_id
  end
end
