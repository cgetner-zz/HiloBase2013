# coding: UTF-8

class CreateJobCriteriaCertificates < ActiveRecord::Migration
  def self.up
    create_table :job_criteria_certificates, :options => "ENGINE=InnoDB" do |t|
    
      t.integer :job_id
      t.integer :certificate_id
      t.boolean :required_flag,:default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :job_criteria_certificates
  end
end
