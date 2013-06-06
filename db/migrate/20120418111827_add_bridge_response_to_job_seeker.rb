# coding: UTF-8

class AddBridgeResponseToJobSeeker < ActiveRecord::Migration
  def change
    add_column :job_seekers, :bridge_response, :string, :default => nil
  end
end
