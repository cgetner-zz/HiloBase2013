class RemoveUnusedColumnsFromJobs < ActiveRecord::Migration
  def self.up
    jobs = Job.where('attachment_file_name IS NOT NULL')
    jobs.each do |job|
      JobAttachment.create(:job_id => job.id,
        :attachment_file_name => job.attachment_file_name,
        :attachment_file_size => job.attachment_file_size,
        :attachment_content_type => job.attachment_content_type,
        :attachment_title => job.attachment_title)
    end
    ActiveRecord::Base.connection.execute("ALTER TABLE `jobs` DROP COLUMN `photoone_file_name`, DROP COLUMN `photoone_content_type`, DROP COLUMN `photoone_file_size`, DROP COLUMN `phototwo_file_name`, DROP COLUMN `phototwo_content_type`, DROP COLUMN `phototwo_file_size`, DROP COLUMN `attachment_file_name`, DROP COLUMN `attachment_file_size`, DROP COLUMN `attachment_content_type`, DROP COLUMN `attachment_title`;")
  end

  def self.down
    ActiveRecord::Base.connection.execute("ALTER TABLE `jobs` ADD COLUMN `photoone_file_name` VARCHAR(255), ADD COLUMN `photoone_content_type` VARCHAR(255), ADD COLUMN `photoone_file_size` INTEGER")
    ActiveRecord::Base.connection.execute("ALTER TABLE `jobs` ADD COLUMN `phototwo_file_name` VARCHAR(255), ADD COLUMN `phototwo_content_type` VARCHAR(255), ADD COLUMN `phototwo_file_size` INTEGER")
    ActiveRecord::Base.connection.execute("ALTER TABLE `jobs` ADD COLUMN `attachment_file_name` VARCHAR(255), ADD COLUMN `attachment_content_type` VARCHAR(255), ADD COLUMN `attachment_file_size` INTEGER, ADD COLUMN `attachment_title` VARCHAR(255)")
    # jobs = JobAttachment.all
    ActiveRecord::Base.connection.execute("TRUNCATE job_attachments")
  end
end
