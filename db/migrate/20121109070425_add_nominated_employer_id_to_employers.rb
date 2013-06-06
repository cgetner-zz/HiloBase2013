class AddNominatedEmployerIdToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :nominated_employer_id, :integer, :default => nil
  end
end
