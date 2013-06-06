class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :job_seeker_id
      t.float :credit_value, :default => 0.0
      t.timestamps
    end
  end
end
