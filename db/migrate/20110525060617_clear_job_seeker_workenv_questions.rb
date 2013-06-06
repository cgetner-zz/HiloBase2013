# coding: UTF-8

class ClearJobSeekerWorkenvQuestions < ActiveRecord::Migration
  def self.up
    
    execute("Truncate job_seeker_workenv_questions")
  end

  def self.down
  end
end
