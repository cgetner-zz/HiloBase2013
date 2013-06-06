# coding: UTF-8

class TruncateJobWorkenvQuestion < ActiveRecord::Migration
  def self.up
  
  ActiveRecord::Base.connection.execute("Truncate job_workenv_questions")
  end

  def self.down
  end
end
