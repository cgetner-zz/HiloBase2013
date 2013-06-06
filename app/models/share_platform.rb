# coding: UTF-8

class SharePlatform < ActiveRecord::Base
  attr_accessible :name
  has_many :log_job_shares
  
  def self.return_platform_hash(platform_id)
      case platform_id.to_s
          when "1"
              return {"id" =>  1, "name" => "Twitter"}
          when "2"    
              return {"id" =>  2, "name" => "Facebook"}
          when "3"
              return {"id" =>  3, "name" => "LinkedIn"}
      end
  end
  
  def self.share_list
      find(:all)
  end
  ##RSPEC: Can't be tested
  def self.get_linkedin_token(callback_url_host,call_from="share_job")
        client = self.generate_linkedin_client()
        begin
              if call_from == "share_hilo"
                  request_token = client.request_token(:oauth_callback => "#{callback_url_host}/share_hilo/save_linkedin_token")
              else
                  request_token = client.request_token(:oauth_callback => "#{callback_url_host}/share_job/save_linkedin_token")
              end
        rescue
              linkedin_token = nil
              linkedin_secret = nil
              linkedin_authorize_url = nil
        else
              linkedin_token = request_token.token
              linkedin_secret = request_token.secret 
              linkedin_authorize_url = request_token.authorize_url
        end
        
        return linkedin_token,linkedin_secret,linkedin_authorize_url
  end
  ##RSPEC: Can't be tested
  def self.verify_linkedin_oauth(oauth_verifier, linkedin_token, linkedin_secret)
      client = self.generate_linkedin_client
      begin
          token_values = client.authorize_from_request(linkedin_token, linkedin_secret,oauth_verifier)
      rescue 
          token = nil
          secret = nil
      else
           token = token_values[0]
           secret = token_values[1]
      end
            
      return token,secret
  end
  ##RSPEC: Can't be tested
  def self.get_twitter_token(callback_url_host,call_from="share_job")
      client = self.generate_twitter_client
      begin 
          if call_from == "share_hilo"
              request_token = client.request_token(:oauth_callback => "#{callback_url_host}/share_hilo/save_twitter_token")
          else
              request_token = client.request_token(:oauth_callback => "#{callback_url_host}/share_job/save_twitter_token")
          end
      rescue
          twitter_token = nil
          twitter_secret = nil
          authorize_url = nil
      else
          twitter_token = request_token.token
          twitter_secret = request_token.secret 
          authorize_url = request_token.authorize_url
      end
      return twitter_token,twitter_secret,authorize_url
  end
  ##RSPEC: Can't be tested
  def self.verify_twitter_oauth(oauth_verifier, twitter_token, twitter_secret)
      client = self.generate_twitter_client
      begin
          access_token = client.authorize(twitter_token,twitter_secret,:oauth_verifier => oauth_verifier)
      rescue
          token = nil
          secret = nil
      else
          if client.authorized?
                token = access_token.token
                secret = access_token.secret
          else      
                token = nil
                secret = nil
          end
       end
            
      return token,secret
  end
  ##RSPEC: Can't be tested
  def self.update_linkedin_status(access_token,secret_token,share_job_id,platform_id, host)
      client = self.generate_linkedin_client()
      client.authorize_from_access(access_token, secret_token)
       msg = form_status_update_message(share_job_id,platform_id, host)
      client.update_status(msg)
  end
  ##RSPEC: Can't be tested
  def self.update_twitter_status(access_token,secret_token,share_job_id,platform_id, host)
      client = TwitterOAuth::Client.new(:consumer_key => $TWITTER_CONSUMER_KEY,:consumer_secret => $TWITTER_CONSUMER_SECRET,:token => access_token,:secret => secret_token)
      msg = form_status_update_message(share_job_id,platform_id, host)
      client.update(msg)
  end
  ##RSPEC: Can't be tested
  def self.update_fb_status(facebook_session,share_job_id,platform_id,host)
      job = Job.find(share_job_id)
      user_fb = facebook_session.user
      
      job_link = "https://#{host}/job/#{job.id}/#{platform_id}"
      user_fb.publish_to(user_fb, :message => "The Hilo Project",
                            :attachment => {:name => "Check out this career opportunity with #{job.company.name} for a
                             #{job.name} #{job_link}",
                                            :href => job_link,
                                            :media => [{:type => "image",
                                                        :src => "https://#{host}/assets/hilo_small.jpg",
                                                        :href => "https://thehiloproject.com"}]},
                            :action_links => [{:text => 'www.thehiloproject.com',
                                               :href => 'https://thehiloproject.com'}])
  end
  ##RSPEC: Can't be tested
  def self.form_status_update_message(share_job_id,platform_id, host)
      job = Job.find(share_job_id)
      #msg = "Check out this Career Opportunity at TheHiloProject.com " + " https://#{host}/job/#{job.id}/#{platform_id}"
      #Check out this career opportunity with [company name] [link] #job @thehiloproject
      if platform_id == SHARE_PLATFORM_TWITTER_ID
        msg = "Check out this career opportunity with #{job.company.name} " + "https://#{host}/job/#{job.id}/#{platform_id} ##{job.name} @thehiloproject"
      elsif platform_id == SHARE_PLATFORM_LINKEDIN_ID
        msg = "Check out this career opportunity with #{job.company.name} for a #{job.name} " + "https://#{host}/job/#{job.id}/#{platform_id}"
      end

  end
  ##RSPEC: Can't be tested
  def self.generate_twitter_client
      TwitterOAuth::Client.new(:consumer_key => $TWITTER_CONSUMER_KEY,:consumer_secret => $TWITTER_CONSUMER_SECRET)
  end
  ##RSPEC: Can't be tested
  def self.generate_linkedin_client
      LinkedIn::Client.new($LINKEDIN_CONSUMER_KEY, $LINKEDIN_CONSUMER_SECRET)
  end
  ##RSPEC: Can't be tested
  def self.linkedin_share_hilo(access_token,secret_token)
      client = self.generate_linkedin_client()
      client.authorize_from_access(access_token, secret_token)
      msg = "Find meaningful employment thru https://TheHiloProject.com"
      client.update_status(msg)
  end
  ##RSPEC: Can't be tested
  def self.twitter_share_hilo(access_token,secret_token)
       client = TwitterOAuth::Client.new(:consumer_key => $TWITTER_CONSUMER_KEY,:consumer_secret => $TWITTER_CONSUMER_SECRET,:token => access_token,:secret => secret_token)
       #msg = "Check out The Hilo Project's limited free beta release at https://www.thehiloproject.com @thehiloproject"
       #Find meaningful employment thru https://TheHiloProject.com #job @thehiloprojec
       msg = "Find meaningful employment thru https://TheHiloProject.com @thehiloproject"
      client.update(msg) 
  end
  ##RSPEC: Can't be tested
  def self.facebook_share_hilo(facebook_session,host)
      user_fb = facebook_session.user
      user_fb.publish_to(user_fb, :message => "The Hilo Project",
                            :attachment => {:name => "Check out The Hilo Project's limited free beta release at https://www.thehiloproject.com
      Hilo is the first human-centered career search tool designed to empower YOU, the Career Seeker, to find truly meaningful  employment.",
                                            :href => "www.thehiloproject.com",
                                            :media => [{:type => "image",
                                                        :src => "https://#{host}/assets/hilo_small.jpg",
                                                        :href => "https://thehiloproject.com"}]},
                            :action_links => [{:text => 'www.thehiloproject.com',
                                               :href => 'https://thehiloproject.com'}])
  end
  
end