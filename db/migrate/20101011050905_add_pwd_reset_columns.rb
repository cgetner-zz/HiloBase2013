# coding: UTF-8

class AddPwdResetColumns < ActiveRecord::Migration
  
  def self.up
      add_column :job_seekers, :fpwd_code,:string
      add_column :employers, :fpwd_code,:string
  end

  def self.down
      remove_column :job_seekers, :fpwd_code
      remove_column :employers, :fpwd_code
  end

end
