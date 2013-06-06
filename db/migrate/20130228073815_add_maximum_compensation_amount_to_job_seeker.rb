class AddMaximumCompensationAmountToJobSeeker < ActiveRecord::Migration
  def change
    add_column :job_seekers,:maximum_compensation_amount, :float, :default => 0
    JobSeeker.all.each do |job_seeker|
      case job_seeker.minimum_compensation_amount.to_i
      when 0..80
        job_seeker.maximum_compensation_amount = job_seeker.minimum_compensation_amount + 20
      when 90
        job_seeker.maximum_compensation_amount = 125
      when 100
        job_seeker.maximum_compensation_amount = 150
      when 125
        job_seeker.maximum_compensation_amount = 200
      when 150
        job_seeker.maximum_compensation_amount = 250
      when 200
        job_seeker.maximum_compensation_amount = 300
      end
      job_seeker.save(:validate=>false)
    end
  end
end
