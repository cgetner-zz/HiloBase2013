# coding: UTF-8

class CreateJobStatuses < ActiveRecord::Migration
  def self.up
    create_table :job_statuses, :options => "ENGINE=InnoDB" do |t|
      t.integer :job_seeker_id
      t.integer :job_id
      t.boolean :follow
      t.boolean :read
      t.boolean :considering
      t.boolean :interested
      t.boolean :wild_card

      t.timestamps
    end
  end

  def self.down
    drop_table :job_statuses
  end
end
