class AddMaximumCompensationAmountToJob < ActiveRecord::Migration
  def change
    add_column :jobs,:maximum_compensation_amount, :float, :default => 0
    Job.all.each do |job|
      case job.minimum_compensation_amount.to_i
      when 0..80
        job.maximum_compensation_amount = job.minimum_compensation_amount + 20
      when 90
        job.maximum_compensation_amount = 125
      when 100
        job.maximum_compensation_amount = 150
      when 125
        job.maximum_compensation_amount = 200
      when 150
        job.maximum_compensation_amount = 250
      when 200
        job.maximum_compensation_amount = 300
      end
      job.save(:validate=>false)
    end
  end
end
