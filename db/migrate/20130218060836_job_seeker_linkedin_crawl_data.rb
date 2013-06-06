class JobSeekerLinkedinCrawlData < ActiveRecord::Migration
  def up
    add_column :job_seekers, :linkedin_crawl_data, :text, :default=>nil
  end

  def down
    remove_column :job_seekers, :linkedin_crawl_data
  end
end
