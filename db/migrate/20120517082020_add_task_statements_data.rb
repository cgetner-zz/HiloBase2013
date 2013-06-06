class AddTaskStatementsData < ActiveRecord::Migration
  def up
#    require 'csv'
#    cmr_path = File.join(Rails.root, "public/csv_files/task_statements.csv")
#    CSV.foreach(cmr_path) do |row|
#      TaskStatement.create!(:onetsoc_code => row[0], :task_id => row[1], :task => row[2], :task_type => row[3], :incumbents_responding => row[4], :date_updated => row[5], :domain_source => row[6])
#    end
  end

  def down
  end
end
