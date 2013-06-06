DynamicSitemaps::Sitemap.draw do
  
  url 'https://thehiloproject.com/', :last_mod => DateTime.now, :change_freq => 'monthly'
  url 'https://thehiloproject.com/employer', :last_mod => DateTime.now, :change_freq => 'monthly'
  url 'https://thehiloproject.com/career_seeker', :last_mod => DateTime.now, :change_freq => 'monthly'
  #url 'https://thehiloproject.com/career_seeker_bridge', :last_mod => DateTime.now, :change_freq => 'monthly'
  url 'https://thehiloproject.com/job_seeker/new', :last_mod => DateTime.now, :change_freq => 'monthly'
  url 'https://thehiloproject.com/employer/new', :last_mod => DateTime.now, :change_freq => 'monthly'
  
  Company.all.each do |company|
    unless company.name.nil?
      unless company.name.blank?
        company_name = company.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
        url 'https://thehiloproject.com/company/'+company_name+'/'+company.id.to_s+'/4', :last_mod => company.updated_at, :change_freq => 'weekly'
      end
    end
  end
  Job.where( :active=>true ,:internal=>false, :deleted => false ).each do |job|
    company = Company.find_by_id(job.company_id)
    company_name = company.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
    job_name = job.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
    url 'https://thehiloproject.com/job/'+company_name+'/'+job_name+'/'+job.id.to_s+'/4', :last_mod => job.updated_at, :change_freq => 'weekly'
  end

end