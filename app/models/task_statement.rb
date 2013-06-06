class TaskStatement < ActiveRecord::Base
  #set_table_name 'task_statements'
  attr_accessible :onetsoc_code, :task_id, :task, :task_type, :incumbents_responding, :date_updated, :domain_source
  belongs_to :occupation_data, :foreign_key=>"onetsoc_code"
end
