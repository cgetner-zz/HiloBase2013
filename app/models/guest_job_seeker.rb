class GuestJobSeeker < ActiveRecord::Base
  attr_accessible :email, :responded_birkman_set_number, :promo_code_sent, :no_result_flag, :js_work_env
  audited
  def self.cron_remind_not_logged_js
    GuestJobSeeker.all.each do |guest_js|
      JobSeeker.where(:activated=>true).each do |js|
        if js.email == guest_js.email
          guest_js.destroy!
        end
      end
    end
    analyzer_hash = Hash.new()
    thinker_hash = Hash.new()
    doer_hash = Hash.new()
    communicator_hash = Hash.new()
    remote_work_hash = Hash.new()

    Job.where(:active => true, :deleted => false, :internal => false).each do |job|
      job_workenv_text = WorkenvQuestion.text_and_color_by_score(job.grid_work_environment_x, job.grid_work_environment_y)
      case job_workenv_text[0].to_s
      when "analyzer"
        if job.remote_work == false
          if not job.job_location.latitude.nil? and not job.job_location.longitude.nil?
            arr = Array.new
            arr << job.job_location.latitude
            arr << job.job_location.longitude
            obj = Geocoder.search(arr.join(','))[0]
            if analyzer_hash.has_key?(obj.city+", "+obj.state+", "+obj.country)
              analyzer_hash[obj.city+", "+obj.state+", "+obj.country] = analyzer_hash[obj.city+", "+obj.state+", "+obj.country] + 1
            else
              analyzer_hash[obj.city+", "+obj.state+", "+obj.country] = 1
            end
          end
        else
          if remote_work_hash.has_key?('analyzer')
            remote_work_hash['analyzer'] = remote_work_hash['analyzer'] + 1
          else
            remote_work_hash['analyzer'] = 1
          end
        end
      when "thinker"
        if job.remote_work == false
          if not job.job_location.latitude.nil? and not job.job_location.longitude.nil?
            arr = Array.new
            arr << job.job_location.latitude
            arr << job.job_location.longitude
            obj = Geocoder.search(arr.join(','))[0]
            if thinker_hash.has_key?(obj.city+", "+obj.state+", "+obj.country)
              thinker_hash[obj.city+", "+obj.state+", "+obj.country] = thinker_hash[obj.city+", "+obj.state+", "+obj.country] + 1
            else
              thinker_hash[obj.city+", "+obj.state+", "+obj.country] = 1
            end
          end
        else
          if remote_work_hash.has_key?('thinker')
            remote_work_hash['thinker'] = remote_work_hash['thinker'] + 1
          else
            remote_work_hash['thinker'] = 1
          end
        end
      when "doer"
        if job.remote_work == false
          if not job.job_location.latitude.nil? and not job.job_location.longitude.nil?
            arr = Array.new
            arr << job.job_location.latitude
            arr << job.job_location.longitude
            obj = Geocoder.search(arr.join(','))[0]
            if doer_hash.has_key?(obj.city+", "+obj.state+", "+obj.country)
              doer_hash[obj.city+", "+obj.state+", "+obj.country] = doer_hash[obj.city+", "+obj.state+", "+obj.country] + 1
            else
              doer_hash[obj.city+", "+obj.state+", "+obj.country] = 1
            end
          end
        else
          if remote_work_hash.has_key?('doer')
            remote_work_hash['doer'] = remote_work_hash['doer'] + 1
          else
            remote_work_hash['doer'] = 1
          end
        end
      when "communicator"
        if job.remote_work == false
          if not job.job_location.latitude.nil? and not job.job_location.longitude.nil?
            arr = Array.new
            arr << job.job_location.latitude
            arr << job.job_location.longitude
            obj = Geocoder.search(arr.join(','))[0]
            if communicator_hash.has_key?(obj.city+", "+obj.state+", "+obj.country)
              communicator_hash[obj.city+", "+obj.state+", "+obj.country] = communicator_hash[obj.city+", "+obj.state+", "+obj.country] + 1
            else
              communicator_hash[obj.city+", "+obj.state+", "+obj.country] = 1
            end
          end
        else
          if remote_work_hash.has_key?('communicator')
            remote_work_hash['communicator'] = remote_work_hash['communicator'] + 1
          else
            remote_work_hash['communicator'] = 1
          end
        end
        puts "*******communicator_hash#{communicator_hash.inspect}"
      end
    end
    GuestJobSeeker.where("no_result_flag = #{true} AND js_work_env IS NOT NULL").each do |g_js|
      puts "************g_js.js_work_env.to_s#{g_js.js_work_env.to_s} and communicator_hash#{communicator_hash.size}"
      case g_js.js_work_env.to_s
      when "analyzer"
        hash_temp = Hash[analyzer_hash.sort_by{ |k,v| -v }]
        if not hash_temp.empty?
          if hash_temp.first.second + remote_work_hash['analyzer'] > 4
            Notifier.remind_not_logged_js(g_js.email).deliver
            g_js.update_attributes(:no_result_flag => false)
          end
        end
      when "thinker"
        hash_temp = Hash[thinker_hash.sort_by{ |k,v| -v }]
        if not hash_temp.empty?
          if hash_temp.first.second + remote_work_hash['thinker'] > 4
            Notifier.remind_not_logged_js(g_js.email).deliver
            g_js.update_attributes(:no_result_flag => false)
          end
        end
      when "doer"
        hash_temp = Hash[doer_hash.sort_by{ |k,v| -v }]
        if not hash_temp.empty?
          if hash_temp.first.second + remote_work_hash['doer'] > 4
            Notifier.remind_not_logged_js(g_js.email).deliver
            g_js.update_attributes(:no_result_flag => false)
          end
        end
      when "communicator"
        hash_temp = Hash[communicator_hash.sort_by{ |k,v| -v }]
        if not hash_temp.empty?
          if hash_temp.first.second + remote_work_hash['communicator'] > 4
            Notifier.remind_not_logged_js(g_js.email).deliver
            g_js.update_attributes(:no_result_flag => false)
          end
        end
      end
    end
  end
end
