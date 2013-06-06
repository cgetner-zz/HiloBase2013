# coding: UTF-8

class ReloadWorkenvQuestions < ActiveRecord::Migration
  def self.up
  execute "truncate workenv_questions"
  end

  def self.down
  end
end
