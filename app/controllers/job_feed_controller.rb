class JobFeedController < ApplicationController

  layout 'job_feed'
  
  def index
    @company = Company.find_by_id(params[:id])
    unless @company.nil?
      @job_feed = Job.job_feed(@company.id)
    else
      render :text => "Invalid URL"
    end
  end

end