require 'net/https'
require 'uri'
require 'geocoder'

class HiloSearchController < ApplicationController
  layout 'registration'

  before_filter :check_logged_in_user
  before_filter :check_work_env_sessions, :only => [:employer_pairing_results, :location_graph]

  def index
    if params[:id] and params[:user_type] == "job_seeker"
      @guest_user = "job_seeker"
      @guest_job_seeker = GuestJobSeeker.find_by_id(params[:id].to_i)

      if @guest_job_seeker and (@guest_job_seeker.test_complete == false || @guest_job_seeker.test_complete.blank?)
        questions_for_work_env(@guest_job_seeker)
        save_citizenship(@guest_job_seeker)
        @guest_job_seeker.responded_birkman_set_number = BIRKMAN_STEP_CITIZENSHIP
        @guest_job_seeker.save(:validate => false)

        respond_to do |format|
          format.html #index.html.erb
        end
      elsif @guest_job_seeker.test_complete == true
        @test_pushed = nil
        @pdf_saved = nil
        submit_birkman_test_for_guest_job_seeker(@guest_job_seeker.id)
        guest_job_seeker = reload_guest_job_seeker(@guest_job_seeker.id)
        @test_pushed = "pushed" if guest_job_seeker.test_submitted == true

        if @test_pushed == "pushed"
          if guest_job_seeker.pdf_saved == false || guest_job_seeker.pdf_saved.blank?
            push_birkman_pdf_download(guest_job_seeker.id, @test_pushed)
            guest_job_seeker = reload_guest_job_seeker(guest_job_seeker.id)
            if guest_job_seeker.pdf_saved == true
              @pdf_saved = "saved"
            end
          end
        end
        #adding "or guest_job_seeker.pdf_saved == true" to stop back button
        if @pdf_saved == "saved" or guest_job_seeker.pdf_saved == true
          session[:search_work_env_msg] = 1 if !@pdf_saved.nil?
          redirect_to hilo_search_pairing_results_path(@guest_job_seeker, {:id => @guest_job_seeker.id, :user_type => "job_seeker"})
        end
      end
    elsif params[:user_type] == "employer"
      @guest_user == "employer"
      @work_questions = WorkenvQuestion.question_list

      respond_to do |format|
        format.html{render :layout => "new_employer_landing_page"}
      end
    else
      redirect_to(:controller => 'employer', :action => 'index')
    end
  end

  # The code for guest job seeker starts from here
  def save_citizenship(guest_job_seeker)
    if guest_job_seeker.responded_birkman_set_number.nil? or guest_job_seeker.responded_birkman_set_number < BIRKMAN_STEP_CITIZENSHIP
      guest_job_seeker.us_citizen = true
      guest_job_seeker.responded_birkman_set_number = BIRKMAN_STEP_CITIZENSHIP
      guest_job_seeker.save(:validate => false)
      if guest_job_seeker.unique_identifier.blank?
        generate_birkman_key(guest_job_seeker)
      end
    end
  end

  def create_guest_job_seeker
    @guest_job_seeker = GuestJobSeeker.new(params[:guest_job_seeker])

    if @guest_job_seeker.save
      render 'create_guest_job_seeker', :format => [:js], :layout => false
      return
    end
  end

  def save_work_env_questions
    @guest_job_seeker = GuestJobSeeker.find_by_id(params[:guest_job_seeker_email].to_i)
    if @guest_job_seeker.responded_birkman_set_number < BIRKMAN_STEP_WORKENV
      GuestJobSeekerWorkenvQuestion.save_workenv_for_jobseeker(params[:work_env_values], @guest_job_seeker.id)

      if @guest_job_seeker.test_complete == true
        @guest_job_seeker.completed_registration_step = QUESTIONNAIRE_STEP
        @guest_job_seeker.save
      end
    end

    redirect_to(hilo_search_index_path(:id => @guest_job_seeker.id, :user_type => "job_seeker"))
    return
  end

  def pairing_results
    @guest_user = params[:user_type]
    @guest_job_seeker = GuestJobSeeker.find_by_id(params[:id].to_i)
    if @guest_user == "job_seeker" and @guest_job_seeker
      pc_email_user = GuestJobSeeker.find_by_email(@guest_job_seeker.email)
      js_email_user = JobSeeker.find_by_email(@guest_job_seeker.email)
      if not pc_email_user.promo_code_sent and not js_email_user.present?
        promo_code = PromotionalCode.create_random_code(22.96,$promo_code_origination[:site_activation_credit])
        pc_email_user.update_attributes(:promo_code_sent => true)
        Notifier.guest_job_seeker_promo_code_mail(pc_email_user.email,promo_code.code,request.env["HTTP_HOST"]).deliver
      end
      js_wokenv = WorkenvQuestion.text_and_color_by_score(@guest_job_seeker.grid_work_environment_x, @guest_job_seeker.grid_work_environment_y)
      session[:js_workenv_text] = nil
      session[:js_workenv_text] = js_wokenv[0]
      session[:gues_js_id] = params[:id].to_i

      respond_to do |format|
        format.html #pairing_results.html.erb
      end
    else
      redirect_to root_path
    end
    
  end

  def push_birkman_pdf_download(guest_job_seeker_id, test_pushed)
    if !test_pushed.nil? and test_pushed  == "pushed"
      guest_job_seeker_download_pdf(guest_job_seeker_id)
    end
  end

  #The code for saving employer work environment questions starts from here
  def save_employer_work_env_questions
    x_score = 0
    y_score = 0
    slider_values_arr_work= params[:work_env_values].split(",")
    work_questions = WorkenvQuestion.question_list

    work_questions.each_with_index{|wq,index|
      if wq.xscoring=="POS"
        x_score = x_score + slider_values_arr_work[index].to_i
      elsif
        wq.xscoring=="NEG"
        x_score= x_score + (4 - slider_values_arr_work[index].to_i)
      end

      if wq.yscoring=="POS"
        y_score= y_score + slider_values_arr_work[index].to_i
      elsif
        wq.yscoring=="NEG"
        y_score= y_score + (4 - slider_values_arr_work[index].to_i)
      end
    }
    session[:map_score_x] = session[:map_score_y] = session[:emp_workenv_text] = session[:emp_workenv_color] = nil
    session[:map_score_x] = $work_env_map_x[x_score]
    session[:map_score_y] = $work_env_map_y[y_score]
    session[:emp_workenv_text], session[:emp_workenv_color] = WorkenvQuestion.text_and_color_by_score(session[:map_score_x], session[:map_score_y])

    render 'show_hilo_search_work_env', :format => [:js], :layout => false
  end

  def employer_pairing_results

    respond_to do |format|
      format.html #employer_pairing_results.html.erb
    end
  end

  def search_job_seekers
    @local_count = 0
    @near_by_count = 0
    @move_count = 0
    @remote_job_seekers = 0
    d = 0
    JobSeeker.where(:activated=>true, :ics_type_id => 4).each do |js|
      js_workenv_text = WorkenvQuestion.text_and_color_by_score(js.job_seeker_birkman_detail.grid_work_environment_x, js.job_seeker_birkman_detail.grid_work_environment_y)
      if js_workenv_text[0] == session[:emp_workenv_text]
        if not js.job_seeker_desired_locations[0].nil?
          if js.job_seeker_desired_locations[0].desired_location_id == 2
            @move_count = @move_count + 1
          else
            if js.job_seeker_desired_locations[0].latitude.nil? or js.job_seeker_desired_locations[0].longitude.nil?
              d = 20037.58
            else
              d = PairingLogic.haversine_distance(params[:search_latitude].to_f, params[:search_longitude].to_f, js.job_seeker_desired_locations[0].latitude, js.job_seeker_desired_locations[0].longitude)
            end
            @local_count = @local_count + 1 if (d >= 0 && d <=50)
            @near_by_count = @near_by_count + 1 if (d > 50 && d <=100)
          end
        end
      end
    end
      
    if @local_count + @near_by_count + @move_count <= 4
      @city_hash = Hash.new()
      @detailed_hash = Hash.new()
      JobSeeker.where(:activated=>true, :ics_type_id => 4).each do |js|
        js_workenv_text = WorkenvQuestion.text_and_color_by_score(js.job_seeker_birkman_detail.grid_work_environment_x, js.job_seeker_birkman_detail.grid_work_environment_y)
        if js_workenv_text[0] == session[:emp_workenv_text]
          if not js.job_seeker_desired_locations[0].nil?
            if js.job_seeker_desired_locations[0].desired_location_id == 1
              if not js.job_seeker_desired_locations[0].latitude.nil? and not js.job_seeker_desired_locations[0].longitude.nil?
                arr = Array.new
                arr << js.job_seeker_desired_locations[0].latitude
                arr << js.job_seeker_desired_locations[0].longitude
                obj = Geocoder.search(arr.join(','))[0]
                if @city_hash[obj.city+", "+obj.state+", "+obj.country].nil?
                  @city_hash[obj.city+", "+obj.state+", "+obj.country] = 1
                  @detailed_hash[obj.city+", "+obj.state+", "+obj.country] = {'lat' => obj.latitude, 'long' => obj.longitude}
                else
                  @city_hash[obj.city+", "+obj.state+", "+obj.country] = @city_hash[obj.city+", "+obj.state+", "+obj.country] + 1
                end
              end
            else
              @remote_job_seekers = @remote_job_seekers + 1
            end
          end
        end
      end
      render 'search_job_seekers_few_records', :format => [:js], :layout => false
    else
      render 'search_job_seekers', :format => [:js], :layout => false
    end
  end

  def search_jobs
    @local_count = 0
    @near_by_count = 0
    @move_count = 0
    @remote_jobs = 0
    d = 0
    Job.where(:active => true, :deleted => false, :internal => false).each do |job|
      job_workenv_text = WorkenvQuestion.text_and_color_by_score(job.grid_work_environment_x, job.grid_work_environment_y)
      if job_workenv_text[0] == session[:js_workenv_text]
        if job.remote_work == true
          @move_count = @move_count + 1
        else
          if job.job_location.latitude.nil? or job.job_location.longitude.nil?
            d = 20037.58
          else
            d = PairingLogic.haversine_distance(params[:search_latitude].to_f, params[:search_longitude].to_f, job.job_location.latitude, job.job_location.longitude)
          end
          @local_count = @local_count + 1 if (d >= 0 && d <=50)
          @near_by_count = @near_by_count + 1 if (d > 50 && d <=100)
        end
      end
    end
    if @local_count + @near_by_count + @move_count <= 4
      @city_hash = Hash.new()
      @detailed_hash = Hash.new()
      Job.where(:active => true, :deleted => false, :internal => false).each do |job|
        job_workenv_text = WorkenvQuestion.text_and_color_by_score(job.grid_work_environment_x, job.grid_work_environment_y)
        if job_workenv_text[0] == session[:js_workenv_text]
          if job.remote_work == false
            if not job.job_location.latitude.nil? and not job.job_location.longitude.nil?
              arr = Array.new
              arr << job.job_location.latitude
              arr << job.job_location.longitude
              begin
                obj = Geocoder.search(arr.join(','))[0]

                if @city_hash[obj.city+", "+obj.state+", "+obj.country].nil?
                  @city_hash[obj.city+", "+obj.state+", "+obj.country] = 1
                  @detailed_hash[obj.city+", "+obj.state+", "+obj.country] = {'lat' => obj.latitude, 'long' => obj.longitude, 'city' => obj.city}
                else
                  @city_hash[obj.city+", "+obj.state+", "+obj.country] = @city_hash[obj.city+", "+obj.state+", "+obj.country] + 1
                end
              rescue
              end
            end
          else
            @remote_jobs = @remote_jobs + 1
          end
        end
      end
      render 'search_jobs_few_records', :format => [:js], :layout => false
    else
      render 'search_jobs', :format => [:js], :layout => false
    end
  end

  def set_no_result_flag_hilo_search
    guest_js = GuestJobSeeker.find_by_id(session[:gues_js_id].to_i)
    guest_js.update_attributes(:no_result_flag => true, :js_work_env => session[:js_workenv_text])
  end

  def location_graph
    @src = params[:src]
    @local_count = 0
    @near_by_count = 0
    @move_count = 0
    d = 0
    if params[:src] == 'employer'
      JobSeeker.where(:activated=>true, :ics_type_id => 4).each do |js|
        js_workenv_text = WorkenvQuestion.text_and_color_by_score(js.job_seeker_birkman_detail.grid_work_environment_x, js.job_seeker_birkman_detail.grid_work_environment_y)
        if js_workenv_text[0] == session[:emp_workenv_text]
          if not js.job_seeker_desired_locations[0].nil?
            if js.job_seeker_desired_locations[0].desired_location_id == 2
              @move_count = @move_count + 1
            else
              if js.job_seeker_desired_locations[0].latitude.nil? or js.job_seeker_desired_locations[0].longitude.nil?
                d = 20037.58
              else
                d = PairingLogic.haversine_distance(params[:lat].to_f, params[:long].to_f, js.job_seeker_desired_locations[0].latitude, js.job_seeker_desired_locations[0].longitude)
              end
              @local_count = @local_count + 1 if (d >= 0 && d <=50)
              @near_by_count = @near_by_count + 1 if (d > 50 && d <=100)
            end
          end
        end
      end
    elsif params[:src] == 'job_seeker'
      Job.where(:active => true, :deleted => false, :internal => false).each do |job|
        job_workenv_text = WorkenvQuestion.text_and_color_by_score(job.grid_work_environment_x, job.grid_work_environment_y)
        if job_workenv_text[0] == session[:js_workenv_text]
          if job.remote_work == true
            @move_count = @move_count + 1
          else
            if job.job_location.latitude.nil? or job.job_location.longitude.nil?
              d = 20037.58
            else
              d = PairingLogic.haversine_distance(params[:lat].to_f, params[:long].to_f, job.job_location.latitude, job.job_location.longitude)
            end
            @local_count = @local_count + 1 if (d >= 0 && d <=50)
            @near_by_count = @near_by_count + 1 if (d > 50 && d <=100)
          end
        end
      end
    end
    render :partial => 'location_graph'
    return
  end

  def birkman_graph
    @src = params[:src]
    @analyzer_count = 0
    @thinker_count = 0
    @doer_count = 0
    @communicator_count = 0
    d = 0
    if params[:src] == 'employer'
      JobSeeker.where(:activated=>true, :ics_type_id => 4).each do |js|
        js_workenv_text = WorkenvQuestion.text_and_color_by_score(js.job_seeker_birkman_detail.grid_work_environment_x, js.job_seeker_birkman_detail.grid_work_environment_y)
        if js_workenv_text[0] == session[:emp_workenv_text]
          js_role_text = RoleQuestion.text_and_color_by_score(js.job_seeker_birkman_detail.grid_work_role_x,js.job_seeker_birkman_detail.grid_work_role_y)
          if not js.job_seeker_desired_locations[0].nil?
            if js.job_seeker_desired_locations[0].desired_location_id == 2
              case js_role_text[0]
              when 'analyzer'
                @analyzer_count = @analyzer_count + 1
              when 'thinker'
                @thinker_count = @thinker_count + 1
              when 'doer'
                @doer_count = @doer_count + 1
              when 'communicator'
                @communicator_count = @communicator_count + 1
              end
            else
              if js.job_seeker_desired_locations[0].latitude.nil? or js.job_seeker_desired_locations[0].longitude.nil?
                d = 20037.58
              else
                d = PairingLogic.haversine_distance(params[:lat].to_f, params[:long].to_f, js.job_seeker_desired_locations[0].latitude, js.job_seeker_desired_locations[0].longitude)
              end
              if d <= 100
                case js_role_text[0]
                when 'analyzer'
                  @analyzer_count = @analyzer_count + 1
                when 'thinker'
                  @thinker_count = @thinker_count + 1
                when 'doer'
                  @doer_count = @doer_count + 1
                when 'communicator'
                  @communicator_count = @communicator_count + 1
                end
              end
            end
          end
        end
      end
    elsif params[:src] == 'job_seeker'
      Job.where(:active => true, :deleted => false, :internal => false).each do |job|
        job_workenv_text = WorkenvQuestion.text_and_color_by_score(job.grid_work_environment_x, job.grid_work_environment_y)
        if job_workenv_text[0] == session[:js_workenv_text]
          job_role_text = RoleQuestion.text_and_color_by_score(job.grid_work_role_x, job.grid_work_role_y)
          if job.remote_work == true
            case job_role_text[0]
            when 'analyzer'
              @analyzer_count = @analyzer_count + 1
            when 'thinker'
              @thinker_count = @thinker_count + 1
            when 'doer'
              @doer_count = @doer_count + 1
            when 'communicator'
              @communicator_count = @communicator_count + 1
            end
          else
            if job.job_location.latitude.nil? or job.job_location.longitude.nil?
              d = 20037.58
            else
              d = PairingLogic.haversine_distance(params[:lat].to_f, params[:long].to_f, job.job_location.latitude, job.job_location.longitude)
            end
            if d <= 100
              case job_role_text[0]
              when 'analyzer'
                @analyzer_count = @analyzer_count + 1
              when 'thinker'
                @thinker_count = @thinker_count + 1
              when 'doer'
                @doer_count = @doer_count + 1
              when 'communicator'
                @communicator_count = @communicator_count + 1
              end
            end
          end
        end
      end
    end
    render :partial => 'birkman_graph'
    return
  end

  def role_cluster_graph
    d = 0
    @src = params[:src]
    @cluster_count = Hash.new()
    if params[:src] == 'employer'
      JobSeeker.where(:activated=>true, :ics_type_id => 4).each do |js|
        flag = false
        js_workenv_text = WorkenvQuestion.text_and_color_by_score(js.job_seeker_birkman_detail.grid_work_environment_x, js.job_seeker_birkman_detail.grid_work_environment_y)
        if js_workenv_text[0] == session[:emp_workenv_text]
          if not js.job_seeker_desired_locations[0].nil?
            if js.job_seeker_desired_locations[0].desired_location_id == 2
              flag = true
            else
              if js.job_seeker_desired_locations[0].latitude.nil? or js.job_seeker_desired_locations[0].longitude.nil?
                d = 20037.58
              else
                d = PairingLogic.haversine_distance(params[:lat].to_f, params[:long].to_f, js.job_seeker_desired_locations[0].latitude, js.job_seeker_desired_locations[0].longitude)
              end
              if d <= 100
                flag = true
              end
            end
          end
        end
        js.added_roles.where(:adder_type => 'JobSeeker').each do |js_add|
          cluster = CareerCluster.find_by_code(js_add.code)
          name = cluster.career_cluster unless cluster.nil?
          if flag and !cluster.nil?
            if @cluster_count[name].nil?
              @cluster_count[name] = 0
            end
            @cluster_count[name] = @cluster_count[name] + 1
          end
        end
        @cluster_count = Hash[@cluster_count.sort_by{ |k,v| -v }[0..9]]
      end
    elsif params[:src] == 'job_seeker'
      Job.where(:active => true, :deleted => false, :internal => false).each do |job|
        flag = false
        job_workenv_text = WorkenvQuestion.text_and_color_by_score(job.grid_work_environment_x, job.grid_work_environment_y)
        if job_workenv_text[0] == session[:js_workenv_text]
          if job.remote_work == true
            flag = true
          else
            if job.job_location.latitude.nil? or job.job_location.longitude.nil?
              d = 20037.58
            else
              d = PairingLogic.haversine_distance(params[:lat].to_f, params[:long].to_f, job.job_location.latitude, job.job_location.longitude)
            end
            if d <= 100
              flag = true
            end
          end
        end
        job.added_roles.where(:adder_type => 'JobPosition').each do |js_add|
          cluster = CareerCluster.find_by_code(js_add.code)
          name = cluster.career_cluster unless cluster.nil?
          if flag
            if @cluster_count[name].nil?
              @cluster_count[name] = 0
            end
            @cluster_count[name] = @cluster_count[name] + 1
          end
        end
        @cluster_count = Hash[@cluster_count.sort_by{ |k,v| -v }[0..9]]
      end
    end
    render :partial => 'role_cluster_graph'
    return
  end

  def wordle_graph
    @src = params[:src]
    @wordle_users = Hash.new
    total_summary = ""
    name_array = Array.new
    d = 0
    if params[:src] == 'employer'
      JobSeeker.where(:activated=>true, :ics_type_id => 4).each do |js|
        js_workenv_text = WorkenvQuestion.text_and_color_by_score(js.job_seeker_birkman_detail.grid_work_environment_x, js.job_seeker_birkman_detail.grid_work_environment_y)
        if js_workenv_text[0] == session[:emp_workenv_text]
          if not js.job_seeker_desired_locations[0].nil?
            if js.job_seeker_desired_locations[0].desired_location_id == 2
              total_summary = total_summary + " " + js.summary if not js.summary.nil?
              name_array << js.first_name if not js.first_name.nil?
              name_array << js.last_name if not js.last_name.nil?
            else
              if js.job_seeker_desired_locations[0].latitude.nil? or js.job_seeker_desired_locations[0].longitude.nil?
                d = 20037.58
              else
                d = PairingLogic.haversine_distance(params[:lat].to_f, params[:long].to_f, js.job_seeker_desired_locations[0].latitude, js.job_seeker_desired_locations[0].longitude)
              end
              total_summary = total_summary + " " + js.summary if ((not js.summary.nil?) and (d >= 0 && d <=100))
              name_array << js.first_name if not js.first_name.nil?
              name_array << js.last_name if not js.last_name.nil?
            end
          end
        end
      end
      @wordle_users = counts_in_array(total_summary, name_array)
    elsif params[:src] == 'job_seeker'
      Job.where(:active => true, :deleted => false, :internal => false).each do |job|
        job_workenv_text = WorkenvQuestion.text_and_color_by_score(job.grid_work_environment_x, job.grid_work_environment_y)
        if job_workenv_text[0] == session[:js_workenv_text]
          if job.remote_work == true
            total_summary = total_summary + " " + job.summary if not job.summary.nil?
          else
            if job.job_location.latitude.nil? or job.job_location.longitude.nil?
              d = 20037.58
            else
              d = PairingLogic.haversine_distance(params[:lat].to_f, params[:long].to_f, job.job_location.latitude, job.job_location.longitude)
            end
            total_summary = total_summary + " " + job.summary if ((not job.summary.nil?) and (d >= 0 && d <=100))
          end
        end
      end
      @wordle_users = counts_in_array(total_summary, name_array)
    end
    render :partial => 'wordle_graph'
    return
  end

  private
  def check_logged_in_user
    if session[:job_seeker] or session[:employer]
      if request.xhr?
        render 'redirect', :format => [:js], :layout => false
      else
        redirect_to root_path
      end
    end
  end
  
  def check_work_env_sessions
    if session[:js_workenv_text].nil? and session[:emp_workenv_text].nil?
      if request.xhr?
        render 'redirect', :format => [:js], :layout => false
      else
        redirect_to root_path
      end
    end
  end
  
  def questions_for_work_env(guest_job_seeker)
    @work_questions = WorkenvQuestion.seeker_next_questions_for_work_env(guest_job_seeker)
    @work_questions_resp = Hash.new
    @work_questions.each_with_index{|obj , i|
      jswq = GuestJobSeekerWorkenvQuestion.find(:first,:conditions=>["guest_job_seeker_id = ? and workenv_question_id = ?",guest_job_seeker.id,obj.id])
      if jswq.nil?
        @work_questions_resp["#{obj.id}"] = nil
      else
        @work_questions_resp["#{obj.id}"] = jswq.score
      end
    }
  end

  def generate_birkman_key(guest_job_seeker)
    @xml_post = form_birkman_key_xml(guest_job_seeker)
    url = URI.parse('https://api.birkman.com/xml-3.0-create.php')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.post(url.path, @xml_post, "content-type" => "text/xml")
    birkman_hash = parse_process_assessment_order_xml_content(response.body)
    if birkman_hash[:error].blank?
      guest_job_seeker.unique_identifier = birkman_hash[:unique_identifier]
      guest_job_seeker.birkman_user_id = birkman_hash[:birkman_user_id]
      guest_job_seeker.save(:validate => false)
    end
    guest_job_seeker = reload_guest_job_seeker(guest_job_seeker.id)
    verify_birkman_id(guest_job_seeker)
  end

  def form_birkman_key_xml(guest_job_seeker)
    redirect_url = "http://#{request.env['HTTP_HOST']}/questionnaire/return_from_birkman"
    language_code = "en-US"
    time_obj = Time.now
    creation_date_time = time_obj.strftime("%Y-%m-%d") + "T" + time_obj.strftime("%H:%M:%S") + "-06:00"
    api_key = BIRKMAN_API_KEY
    user_email = guest_job_seeker.email

    xml_request = "<?xml version='1.0' encoding='UTF-8'?>
          <ProcessAssessmentOrder systemEnvironmentCode='#{$BIRKMAN_MODE}' releaseID='3.0' languageCode='en-US' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns='http://www.hr-xml.org/3' xmlns:oa='http://www.openapplications.org/oagis/9'>
                <oa:ApplicationArea>
                  <oa:Sender>
                    <!-- your API key goes here -->
                    <oa:AuthorizationID>#{api_key}</oa:AuthorizationID>
                  </oa:Sender>
                  <!-- ISO 8601 formatted timestamp -->
                  <oa:CreationDateTime>#{creation_date_time}</oa:CreationDateTime>
                </oa:ApplicationArea>

                <DataArea>
                  <oa:Process acknowledgeCode='Always'/>
                  <AssessmentOrder>
                      <AssessmentSubject>
                        <Communication>
                          <ChannelCode>email</ChannelCode>
                          <oa:URI>#{user_email}</oa:URI>
                        </Communication>
                        <UserArea/>
                      </AssessmentSubject>
                      <!-- language in ISO-639-1 format -->
                      <AssessmentLanguageCode>#{language_code}</AssessmentLanguageCode>
                      <oa:RedirectURL>#{redirect_url}</oa:RedirectURL>
                      <UserArea>"
    if $BIRKMAN_MODE != "Production"
      xml_request  <<   "<TestMode>1</TestMode>
                            <!-- a value of 1 will allow auto filling of the answers if TestMode=1 -->
                          <AutoFill>1</AutoFill>"
    end

    xml_request  <<   "<!-- only use clientdata if you have a prev. agreement to do so -->
                          <ClientData></ClientData>
                          <!-- timeout value in seconds, any value > 0 will trigger -->
                          <RedirectURLTimeout>0</RedirectURLTimeout>
                          <!-- any value here will replace the default supplied by Birkman -->
                          <RedirectURLText>Click here to continue with Koro</RedirectURLText>
                          <!-- additional meta data to use for searching -->
                          <Tracking></Tracking>
                      </UserArea>
                  </AssessmentOrder>
                </DataArea>
            </ProcessAssessmentOrder>"
    return xml_request
  end

  def parse_process_assessment_order_xml_content(xml_data)
    birkman_hash = {:error=>"",:unique_identifier =>"",:birkman_user_id=>""}

    begin
      xml_doc = REXML::Document.new(xml_data)
      xml_doc.elements.each("//ErrorProcessMessage"){|element|
        birkman_hash[:error] = element.elements['Description'].text
      }

      if  birkman_hash[:error].blank?
        xml_doc.elements.each("//AssessmentOrder") { |element|
          birkman_hash[:birkman_user_id] = birkman_hash[:unique_identifier] = element.elements['DocumentID'].text
        }
      end
    rescue =>e
      birkman_hash[:error] = "Failed to initialize Birkman"
    end
    return birkman_hash
  end

  def verify_birkman_id(guest_job_seeker)
    @xml_post = verify_xml("Hector", "Sample", "#{guest_job_seeker.email}")
    url = URI.parse('https://api.birkman.com/xml-3.0-transfer.php')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.post(url.path, @xml_post,'content-type'=>'text/xml')

    @verify_hash = parse_verify_xml(response.body)

    if @verify_hash[:error].blank?
      guest_job_seeker.unique_identifier = @verify_hash[:document_id]
      guest_job_seeker.birkman_user_id = @verify_hash[:document_id]
      guest_job_seeker.save(:validate => false)
    else
      logger.info("*********@verify_hash[:error] is #{@verify_hash[:error]}**************")
    end
  end

  def verify_xml(first_name, last_name, email)
    passthrough_birkman_ids = ["D00106", "D00107", "D00108", "D00109"]
    user_birkman_key = passthrough_birkman_ids.sample
    logger.info("user_birkman_key is **************#{user_birkman_key}*************")
    time_obj = Time.now
    creation_date_time = time_obj.strftime('%Y-%m-%d') + 'T' + time_obj.strftime('%H:%M:%S') + '-06:00'
    api_key = BIRKMAN_API_KEY

    xml = "<?xml version='1.0' encoding='UTF-8'?>
                <ProcessAssessmentReport releaseID='3.0' versionID='1.2' systemEnvironmentCode='#{$BIRKMAN_MODE}' languageCode='en-US'
                 xmlns='http://www.hr-xml.org/3' xmlns:oa='http://www.openapplications.org/oagis/9'>

                   <oa:ApplicationArea>
                      <oa:Sender>
                        <!-- your API key goes here -->
                        <oa:AuthorizationID>#{api_key}</oa:AuthorizationID>
                      </oa:Sender>
                      <!-- ISO 8601 formatted timestamp -->
                      <oa:CreationDateTime>#{creation_date_time}</oa:CreationDateTime>
                   </oa:ApplicationArea>

                   <DataArea>
                     <oa:Process acknowledgeCode='Always'>
                        <oa:ActionCriteria>
                           <oa:ActionExpression actionCode=''></oa:ActionExpression>
                        </oa:ActionCriteria>
                     </oa:Process>
                      <AssessmentReport>
                         <DocumentID schemeID='BirkmanID'>#{user_birkman_key}</DocumentID>

                         <!-- AssessmentSubject fields required for a global xfer -->
                         <AssessmentSubject>
                            <PersonName>
                               <oa:GivenName>#{first_name}</oa:GivenName>
                               <FamilyName>#{last_name}</FamilyName>
                            </PersonName>
                            <Communication>
                               <ChannelCode>Email</ChannelCode>
                               <oa:URI>#{email}</oa:URI>
                            </Communication>
                            <BirthDate>1933-03-31</BirthDate>
                         </AssessmentSubject>
                      </AssessmentReport>
                   </DataArea>
                </ProcessAssessmentReport>"
    return xml
  end

  def parse_verify_xml(xml_data)
    verify_hash = {:error=>"",:document_id => ""}

    begin
      xml_doc = REXML::Document.new(xml_data)
      xml_doc.elements.each("//ErrorProcessMessage"){|element|
        verify_hash[:error] = element.elements['Description'].text
      }

      if  verify_hash[:error].blank?
        xml_doc = REXML::Document.new(xml_data)

        xml_doc.elements.each("//AssessmentReport") { |element|
          verify_hash[:document_id] = element.elements['AlternateDocumentID'].text
        }
      end
    rescue => e
      verify_hash[:error] = "Error Occurred"
      raise e
    end
    return verify_hash
  end

  def submit_birkman_test_for_guest_job_seeker(guest_job_seeker_id)
    guest_job_seeker = GuestJobSeeker.find_by_id(guest_job_seeker_id)
    @xml_post = form_passthrough_response_xml(guest_job_seeker_id)
    url = URI.parse('https://api.birkman.com/xml-3.0-append.php')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.post(url.path, @xml_post,"content-type"=>"text/xml")
    JobSeekerBirkmanDetail.parse_test_submit_xml(response.body, guest_job_seeker)
    return @xml_post,response
  end

  def form_passthrough_response_xml(guest_job_seeker_id)
    guest_job_seeker = GuestJobSeeker.find_by_id(guest_job_seeker_id)
    time_obj = Time.now
    creation_date_time = time_obj.strftime("%Y-%m-%d") + "T" + time_obj.strftime("%H:%M:%S") + "-06:00"
    api_key = BIRKMAN_API_KEY
    unique_key = guest_job_seeker.unique_identifier
    first_name = "Hector"
    last_name = "Sample"
    test_weq_xml = ""

    jwq_resp = GuestJobSeekerWorkenvQuestion.where("guest_job_seeker_id = ?", guest_job_seeker_id).all
    jwq_resp.each_with_index{|ans,cnt|
      test_weq_xml << "<Item section='bweq' sequence='#{(cnt + 1)}'><Response type='multichoice' sequence=''>#{ans.score}</Response></Item>"
    }

    return xml = "<?xml version='1.0' encoding='UTF-8'?>
                <ProcessCandidate releaseID='3.0' versionID='1.2'    systemEnvironmentCode='#{$BIRKMAN_MODE}' languageCode='en-US'
                 xmlns='http://www.hr-xml.org/3' xmlns:oa='http://www.openapplications.org/oagis/9'>

                   <oa:ApplicationArea>
                      <oa:Sender>
                        <!-- your API key goes here -->
                        <oa:AuthorizationID>#{api_key}</oa:AuthorizationID>
                      </oa:Sender>
                      <!-- ISO 8601 formatted timestamp -->
                      <oa:CreationDateTime>#{creation_date_time}</oa:CreationDateTime>
                   </oa:ApplicationArea>

                   <DataArea>
                     <oa:Process>
                        <oa:ActionCriteria>
                           <oa:ActionExpression actionCode=''></oa:ActionExpression>
                        </oa:ActionCriteria>
                     </oa:Process>
                    <Candidate>
                         <DocumentID schemeID='UserID'>#{unique_key}</DocumentID>
                        <CandidatePerson>
                          <PersonName>
                            <oa:GivenName>#{first_name}</oa:GivenName>
                            <MiddleName></MiddleName>
                            <FamilyName>#{last_name}</FamilyName>
                          </PersonName>
                        </CandidatePerson>

                         <UserArea>
                         <AssessmentItems>
                                #{test_weq_xml}
                         </AssessmentItems>
                         </UserArea>

                     </Candidate>
                   </DataArea>
                </ProcessCandidate>"
  end

  def guest_job_seeker_download_pdf(guest_job_seeker_id)
    guest_job_seeker = GuestJobSeeker.find_by_id(guest_job_seeker_id)
    flag,xml_post,response = ""
    if guest_job_seeker.test_complete == true and guest_job_seeker.test_submitted == true
      flag,xml_post,response = download_pdf(guest_job_seeker)
    end
    return flag,xml_post,response
  end

  def download_pdf(guest_job_seeker)
    @xml_post = xml_for_pdf_report(guest_job_seeker)

    url = URI.parse('https://api.birkman.com/xml-3.0-report.php')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.post(url.path, @xml_post, "content-type"=>"text/xml")

    pdf_hash = JobSeekerBirkmanDetail.parse_pdf_report_xml(response.body)

    if pdf_hash[:error].blank? and ["OrderComplete","ScoredTestPendingReview"].include?(pdf_hash[:status_code])
      # create_pdf_file(pdf_hash,guest_job_seeker)
      JobSeekerBirkmanDetail.save_work_role_score(pdf_hash, guest_job_seeker)
      guest_job_seeker.pdf_saved = true
      guest_job_seeker.save(:validate => false)
      return true,@xml_post,response
    else
      return false,@xml_post,response
    end
  end

  def xml_for_pdf_report(guest_job_seeker)
    time_obj = Time.now
    creation_date_time = time_obj.strftime("%Y-%m-%d") + "T" + time_obj.strftime("%H:%M:%S") + "-06:00"
    api_key = BIRKMAN_API_KEY
    #PDFFormatID -> 2400284 - this gives career forward guide
    #PDFFormatID -> 2400111 - this give interest report
    @xml_post= "<GetAssessmentReport systemEnvironmentCode='#{$BIRKMAN_MODE}' releaseID='3.0' languageCode='en-US'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns='http://www.hr-xml.org/3' xmlns:oa='http://www.openapplications.org/oagis/9'>

       <oa:ApplicationArea>
          <oa:Sender>
            <oa:ConfirmationCode>OnError</oa:ConfirmationCode>
            <!-- your API key goes here -->
            <oa:AuthorizationID>#{api_key}</oa:AuthorizationID>
          </oa:Sender>
          <!-- ISO 8601 formatted timestamp -->
          <oa:CreationDateTime>#{creation_date_time}</oa:CreationDateTime>
       </oa:ApplicationArea>

       <DataArea>
          <oa:Get>
             <oa:Expression/>
          </oa:Get>
          <AssessmentReport>
             <DocumentID>#{guest_job_seeker.unique_identifier}</DocumentID>
             <UserArea>
                <!-- 0 for false, 1 for true -->
                <CSVOutput>1</CSVOutput>
                <!-- 1 or more PDFFormat tags will create those reports -->
                <PDFFormatID>2400284</PDFFormatID>

             </UserArea>

          </AssessmentReport>
       </DataArea>
    </GetAssessmentReport>"
    return @xml_post
  end

  def reload_guest_job_seeker(guest_job_seeker_id)
    guest_job_seeker = GuestJobSeeker.find_by_id(guest_job_seeker_id)
    return guest_job_seeker
  end

  def counts_in_array(total_summary, name_array)
    ignore_word_str = "a's, able, about, above, according, accordingly, across, actually, after, afterwards, again, against, ain't, all, allow, allows, almost, alone, along, already, also, although, always, am, among, amongst, an, and, another, any, anybody, anyhow, anyone, anything, anyway, anyways, anywhere, apart, appear, appreciate, appropriate, are, aren't, around, as, aside, ask, asking, associated, at, available, away, awfully, be, became, because, become, becomes, becoming, been, before, beforehand, behind, being, believe, below, beside, besides, best, better, between, beyond, both, brief, but, by, c'mon, c's, came, can, can't, cannot, cant, cause, causes, certain, certainly, changes, clearly, co, com, come, comes, concerning, consequently, consider, considering, contain, containing, contains, corresponding, could, couldn't, course, currently, definitely, described, despite, did, didn't, different, do, does, doesn't, doing, don't, done, down, downwards, during, each, edu, eg, eight, either, else, elsewhere, enough, entirely, especially, et, etc, even, ever, every, everybody, everyone, everything, everywhere, ex, exactly, example, except, far, few, fifth, first, five, followed, following, follows, for, former, formerly, forth, four, from, further, furthermore, get, gets, getting, given, gives, go, goes, going, gone, got, gotten, greetings, had, hadn't, happens, hardly, has, hasn't, have, haven't, having, he, he's, hello, help, hence, her, here, here's, hereafter, hereby, herein, hereupon, hers, herself, hi, him, himself, his, hither, hopefully, how, howbeit, however, i'd, i'll, i'm, i've, ie, if, ignored, immediate, in, inasmuch, inc, indeed, indicate, indicated, indicates, inner, insofar, instead, into, inward, is, isn't, it, it'd, it'll, it's, its, itself, just, keep, keeps, kept, know, knows, known, last, lately, later, latter, latterly, least, less, lest, let, let's, like, liked, likely, little, look, looking, looks, ltd, mainly, many, may, maybe, me, mean, meanwhile, merely, might, more, moreover, most, mostly, much, must, my, myself, name, namely, nd, near, nearly, necessary, need, needs, neither, never, nevertheless, new, next, nine, no, nobody, non, none, noone, nor, normally, not, nothing, novel, now, nowhere, obviously, of, off, often, oh, ok, okay, old, on, once, one, ones, only, onto, or, other, others, otherwise, ought, our, ours, ourselves, out, outside, over, overall, own, particular, particularly, per, perhaps, placed, please, plus, possible, presumably, probably, provides, que, quite, qv, rather, rd, re, really, reasonably, regarding, regardless, regards, relatively, respectively, right, said, same, saw, say, saying, says, second, secondly, see, seeing, seem, seemed, seeming, seems, seen, self, selves, sensible, sent, serious, seriously, seven, several, shall, she, should, shouldn't, since, six, so, some, somebody, somehow, someone, something, sometime, sometimes, somewhat, somewhere, soon, sorry, specified, specify, specifying, still, sub, such, sup, sure, t's, take, taken, tell, tends, th, than, thank, thanks, thanx, that, that's, thats, the, their, theirs, them, themselves, then, thence, there, there's, thereafter, thereby, therefore, therein, theres, thereupon, these, they, they'd, they'll, they're, they've, think, third, this, thorough, thoroughly, those, though, three, through, throughout, thru, thus, to, together, too, took, toward, towards, tried, tries, truly, try, trying, twice, two, un, under, unfortunately, unless, unlikely, until, unto, up, upon, us, use, used, useful, uses, using, usually, value, various, very, via, viz, vs, want, wants, was, wasn't, way, we, we'd, we'll, we're, we've, welcome, well, went, were, weren't, what, what's, whatever, when, whence, whenever, where, where's, whereafter, whereas, whereby, wherein, whereupon, wherever, whether, which, while, whither, who, who's, whoever, whole, whom, whose, why, will, willing, wish, with, within, without, won't, wonder, would, would, wouldn't, yes, yet, you, you'd, you'll, you're, you've, your, yours, yourself, yourselves, zero"
    ignore_word_arr = ignore_word_str.split(", ")
    ignore_word_arr.concat name_array
    temp_count = 0
    total_summary_array = total_summary.scan(/\w+/)
      counts = Hash.new()
      for word in total_summary_array
        if not ignore_word_arr.include?(word.downcase)
          temp_count = temp_count + 1
          if counts[word].nil?
            counts[word] = 0
          end
          counts[word] = counts[word] + 1
        end
        if temp_count > 100
          break
        end
      end
      return counts.sort_by{ |k,v| -v }
  end
end