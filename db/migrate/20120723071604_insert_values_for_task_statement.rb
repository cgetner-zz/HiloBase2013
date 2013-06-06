class InsertValuesForTaskStatement < ActiveRecord::Migration
  def up
    execute("TRUNCATE task_statements")
    require 'csv'
    task_statements_path = File.join(Rails.root, "public/csv_files/update_task_statement.csv")
    CSV.foreach(task_statements_path) do |row|
      TaskStatement.create!(:onetsoc_code => row[0], :task_id => row[1], :task => row[2], :task_type => row[3], :incumbents_responding => row[4], :date_updated => row[5], :domain_source => row[6])
    end
  end

  def down
    execute("TRUNCATE task_statements")
  end
end
