# coding: UTF-8

class AjaxController < ApplicationController
  before_filter :validate_job_for_employer, :only=> [:work_question, :save_work_question, :role_question, :save_role_question]
  before_filter :check_employer_job_save_permission, :only=> [:duplicate_job]
  before_filter :validate_new_user, :only => [:create_new_user]
  before_filter :check_for_deleted_users
  before_filter :check_for_suspended_users
  before_filter :check_availability, :only => [:category_reassign, :position_reassign]
  layout false

  def set_locale_session
    session[:locale] = params[:locale]
    respond_to do |format|
      format.js
    end
  end

  def check_for_job_link
    job_id = params[:job_id]
    job = Job.find_by_id(job_id)
    unless job.nil?
      if job.job_link.nil?
        render :text => "NULL"
      else
        if not job.job_link.blank?
          website = job.job_link.split("//")
          if not (website[0] == "http:" or website[0] == "https:")
            job.job_link = "http://"+job.job_link.to_s
          else
            job.job_link = job.job_link
          end
        else
          render :text => "NULL"
        end
        render :text => job.job_link
      end
    else
      render :text => "NULL"
    end
  end

  def download_csv
    send_data params[:csv_data], :type => "text/csv", :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=Payment_History.csv"
  end

  def delete_saved_search
    ss = CareerSeekerSavedSearch.find(params[:saved_id].to_i)
    ss.update_attribute(:deleted, true)
    reload_seeker_session
    render :text=>"Done"
  end

  def reset_ics_url
    random_token = Company.set_random_token(session[:employer].company_id)
    company = Company.find(session[:employer].company_id)
    company_name = company.name.gsub(/[^0-9a-z ]/i,'').gsub(' ','-')
    bitly = Bitly.new($BITLY_KEY,$BITLY_SECRET)
    ics_url = bitly.shorten('https://thehiloproject.com/'+company_name+'/internal_candidate/'+session[:employer].company_id.to_s+'/'+random_token)
    render :text => ics_url.shorten
  end

  def delete_saved_search_employer
    es = EmployerSavedSearch.find(params[:saved_id].to_i)
    es.update_attribute(:deleted, true)
    reload_employer_session
    render :text=>"Done"
  end

  def save_seeker_search
    CareerSeekerSavedSearch.create(:job_seeker_id=>session[:job_seeker].id, :keyword=>params[:keyword], :name=>params[:name])
    reload_seeker_session
  end

  def save_employer_search
    EmployerSavedSearch.create(:employer_id => session[:employer].id, :keyword => params[:keyword], :name => params[:name])
    reload_employer_session
  end
  
  def save_group_name
    cg = CompanyGroup.where(:id=>params[:id]).first
    cg.name = params[:group_name]
    cg.save
    cg.errors.each{|k,v|
      @error_arr << [k,v]
    }
    @error_json = json_from_error_arr(@error_arr )
    render :update do |page|
      if @error_arr.length > 0
        page.call "emp_left_menu_event.save_fail", @error_json
      else
        reload_employer_session
        @ancestors = session[:employer].ancestor_ids
        @jobs = session[:employer].get_jobs_with_group(@ancestors)
        @job_statuses = Job.get_job_status(@jobs,session[:employer].id)
        condition = Employer.find(session[:employer].id).subtree_ids.join(',')
        @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
        @current_employer= Employer.where("id=?", session[:employer].id).first
        @selected_category_size = 0
        Employer.find(session[:employer].id).subtree.each do |emp|
          @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
        end
        page.replace_html 'update_categories', :partial => "/employer_account/employer_left_menu/", :locals=>{:jobs => @jobs}
      end
    end
      
  end

  def fetch_my_categories
    label_names = []
    label_ids = []
    reload_employer_session
    session[:employer].company_groups.where(:deleted=>false).order("sort_index ASC").each {|i|
      label_ids<<i.id
      label_names<<i.name
    }
    label_ids = label_ids.map{|m| m}.join("_")
    label_names = label_names.map{|m| m}.join("_")
    @categories = (label_ids.concat("_joined_")).concat(label_names)
    render :text=>@categories
  end

  def set_xref_selected
    if session[:selected].nil?
      if params[:selected].nil?
        session[:selected] = -1
      else
        session[:selected] = params[:selected]
      end
    end
    render :text => session[:selected]
  end

  def show_gift_hilo
    render 'show_gift_hilo', :format => [:js], :layout => false
    return
  end 

  def save_category
    reload_employer_session
    ids = params[:uniq_cat_ids].split(",") #ids is an array obj
    if !ids.nil?
      ids.each do |id|
        cat_name = params["group_name_#{id}"].to_s
        if !cat_name.blank?
          cg = CompanyGroup.find(id.to_i)
          if session[:employer].subtree_ids.include?(cg.employer_id) and cg.deleted == false
            cg.name = cat_name
            cg.save
            cg.errors.each{|k,v|
              @error_arr << [k,v]
            }
          end
        else
          next
        end
      end        
      if params[:parent_id] == '-1'
        ancestors = session[:employer].ancestor_ids
        subtree = session[:employer].subtree_ids
        @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      elsif params[:parent_id] == '0'
        ancestors = session[:employer].ancestor_ids
        descendants = session[:employer].descendant_ids
        @jobs = session[:employer].get_my_positions(ancestors, descendants)
      else
        emp = Employer.find_by_id(params[:parent_id])
        ancestors = emp.ancestor_ids
        subtree = emp.subtree_ids
        @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      end
      @employer_category_size = Employer.find(session[:employer].id).company_groups.where(:deleted=>false).size
      condition = Employer.find(session[:employer].id).subtree_ids.join(',')
      @all_jobs_size = Job.where("employer_id IN (#{condition}) and deleted=?" , false).all.size
      @current_employer= Employer.where("id=?", session[:employer].id).first
      @selected_category_size = 0
      Employer.find(session[:employer].id).subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      render 'save_category', :formats=>[:js], :layout=>false
    else
      render :nothing => true  
    end
  end
  

  def sort_group_ajax
    cgs = CompanyGroup.where("id IN (?)", params[:sort_group])
    sorted_arr = cgs.collect{|c| c.sort_index}.sort
    cgs.each do |c|
      pos = params[:sort_group].index(c.id.to_s)
      c.sort_index = sorted_arr[pos.to_i].to_i
      c.save(:validate => false)
    end
    render :text => "done"    
  end
  
  def sort_group_job_ajax
    begin
      job_ids = params[:box_jobs].split(",")
      sort_index = []
      job_ids.each do |j|
        job = Job.where(:id => j.to_i).first
        sort_index.push(job.sort_index) if(!job.nil?)
      end
      sort_index.sort!
      index = 0
      
      job_ids.each do |ji|
        job = Job.where(:id => ji.to_i).first
        if !job.nil?
          job.company_group_id = params[:company_group_id].to_i
          job.sort_index = sort_index[index]
          job.save!(:validate=>false)
        end
        index = index + 1
      end
    rescue
    end
    render :text => "done"
  end
  
  def push_birkman_test_submission
    session[:account_popup] = 1
    # @test_pushed = nil
    JobSeekerBirkmanDetail.delay(:priority => 1).job_seeker_submit_birkman_test(session[:job_seeker].id)
    reload_seeker_session(session[:job_seeker])
    JobSeekerBirkmanDetail.delay(:priority => 2).job_seeker_download_pdf(session[:job_seeker].id)
    reload_seeker_session(session[:job_seeker])
    PairingLogic.delay(:priority => 3).pairing_value_job_seeker_jobs(session[:job_seeker])
    respond_to do |format|
      format.js {render 'push_birkman_test_submission.js.erb', :layout=>false}
    end
=begin
    if @test_pushed.nil?
      if(session[:job_seeker].job_seeker_birkman_detail.test_submitted == true)
        @test_pushed = "pushed"
      else
        respond_to do |format|
          format.js {render 'push_birkman_test_submission.js.erb', :layout=>false}
        end
      end
    end

    if @test_pushed == "pushed"
      if session[:job_seeker].job_seeker_birkman_detail.pdf_saved == false
        push_birkman_pdf_download(@test_pushed)
        reload_seeker_session(session[:job_seeker])
        if session[:job_seeker].job_seeker_birkman_detail.pdf_saved == true
          run_pairing_logic("download")
        end
        respond_to do |format|
          format.js {render 'push_birkman_test_submission.js.erb', :layout=>false}
        end
      else
        run_pairing_logic("download")
        respond_to do |format|
          format.js {render 'push_birkman_test_submission.js.erb', :layout=>false}
        end
      end
    end
=end
  end

=begin
  def push_birkman_pdf_download(test_pushed)
    if !test_pushed.nil? and test_pushed  == "pushed"
      JobSeekerBirkmanDetail.delay(:priority => 2).job_seeker_download_pdf(session[:job_seeker].id)
      test_pushed = "download"
    end
  end

  def run_pairing_logic(test_pushed)
    if test_pushed == "download"
      job_seeker = JobSeeker.where(:id => session[:job_seeker].id).first
      PairingLogic.delay.pairing_value_job_seeker_jobs(job_seeker)
    end
  end
=end

  def get_degrees
    json_arr = []
    degrees = Degree.where("name like ?", "%" + params[:query] + "%").all
    for degree in degrees
      json_arr << degree.name
    end
    json_string = ""
    if not json_arr.blank?
      json_string = "'" + json_arr.uniq.join("','") + "'"
    end

    render :json => "{query:'#{params[:query]}' ,suggestions:[ " + json_string + "]}"
    return
  end
  
  def get_certificates
    json_arr = []
    json_arr_new = []
    conditions = "activated = 1"
    
    certificates = NewCertificate.select("`certification_name` as name").where("(#{conditions}) AND `certification_name` like ?","%" + params[:query] + "%").all
    for certificate in certificates
      json_arr << certificate.name
    end

    licenses = License.select("`license_name` as name").where("(#{conditions}) AND `license_name` like ?","%" + params[:query] + "%").all
    for license in licenses
      json_arr << license.name
    end
    
    json_arr.sort!
    
    if json_arr.size > 50
      1.upto(50) {|i|
        json_arr_new << json_arr[i-1]
      }
    end

    json_string = ""
    if !json_arr_new.blank?
      json_string = "'" + json_arr_new.uniq.join("','") + "'"
    elsif !json_arr.blank?
      json_string = "'" + json_arr.uniq.join("','") + "'"
    end
    
    render :json => "{query:'#{params[:query]}' ,suggestions:[ " + json_string + "]}"
    return
  end
  
  def get_certificates_for_employer
    json_arr = []
    json_arr_new = []
    conditions = "activated = 1"

    certificates = NewCertificate.select("`certification_name` as name").where("(#{conditions}) AND `certification_name` like ?","%" + params[:query] + "%").all
    for certificate in certificates
      json_arr << certificate.name
    end

    licenses = License.select("`license_name` as name").where("(#{conditions}) AND `license_name` like ?","%" + params[:query] + "%").all
    for license in licenses
      json_arr << license.name
    end

    if json_arr.size > 100
      1.upto(100) {|i|
        json_arr_new << json_arr[i-1]
      }
    end

    json_string = ""
    if !json_arr_new.blank?
      json_string = "'" + json_arr_new.uniq.join("','") + "'"
    elsif !json_arr.blank?
      json_string = "'" + json_arr.uniq.join("','") + "'"
    end

    render :json => "{query:'#{params[:query]}' ,suggestions:[ " + json_string + "]}"
    return
  end
  
  
  def get_proficiencies
    json_arr = []
    conditions = "activated = 1"
    proficiencies = Proficiency.where("(#{conditions}) AND name like ?","%" + params[:query] + "%").all
    for proficiency in proficiencies
      json_arr << proficiency.name
    end
      
    json_string = ""
    if not json_arr.blank?
      json_string = "'" + json_arr.uniq.join("','") + "'"
    end
      
    render :json => "{query:'#{params[:query]}', suggestions:[ " + json_string + "]}"
    return
  end
   
  def get_proficiencies_for_employer
    json_arr = []
    conditions = "activated = 1"
    proficiencies = Proficiency.where("(#{conditions}) AND name like ?","%" + params[:query] + "%").all
    for proficiency in proficiencies
      json_arr << proficiency.name
    end
      
    json_string = ""
    if not json_arr.blank?
      json_string = "'" + json_arr.uniq.join("','") + "'"
    end
      
    render :json => "{query:'#{params[:query]}' ,suggestions:[ " + json_string + "]}"
    return
  end
    
  def list_proficiencies
    @proficiencies = Proficiency.all.where("activated = 1")
  end
  
  def work_question
    @job = Job.find(params[:job_id])
    @work_questions = WorkenvQuestion.question_list 
    @job_we_ques = JobWorkenvQuestion.all.where("job_id = ?",@job.id).order("id asc").map{|e| e.score}
  end
  
  def save_work_question
    job = Job.where(params[:job_id])
    job.personality_work_complete = true
    job.save(:validate => false)
    work_questions = WorkenvQuestion.question_list 
       
    slider_values_arr = params[:slider_values].split(",")
       
    JobWorkenvQuestion.delete_all("job_id = '#{job.id}'")
       
    work_questions.each_with_index{|wq,index|
      JobWorkenvQuestion.create({:workenv_question_id => wq.id,:score=>slider_values_arr[index],:job_id=>job.id})
    }
    job.save_work_env_score
    render :update do |page|
      page.call "reload_page"
    end
  end
      
  def update_workenv_image
    job = Job.where(params[:job_id])
    x_score,y_score = job.work_env_score
    image_name = WorkenvQuestion.image_by_score(x_score,y_score )
    render :text=> image_name
    return
  end
  
  def role_question
    @job = Job.where(params[:job_id])
    @role_questions = RoleQuestion.question_list
    @job_role_ques = JobRoleQuestion.where("job_id = ?",@job.id).order("id asc").map{|e| e.score}
  end
    
  def save_role_question
    job = Job.where(params[:job_id])
    job.personality_role_complete = true
    job.save(:validate => false)
    role_questions = RoleQuestion.question_list
      
    slider_values_arr = params[:slider_values].split(",")
      
    JobRoleQuestion.delete_all("job_id = '#{job.id}'")
      
    role_questions.each_with_index{|rq,index|
      JobRoleQuestion.create({:role_question_id => rq.id,:score=>slider_values_arr[index],:job_id=>job.id})
    }
       
    job.save_role_env_score
    render :update do |page|
      page.call "reload_page"
    end
      
  end
  
  def get_group_names
    split_words = params[:query].split(" ")
    json_arr = []
      
    company_grps = session[:employer].get_groups(params[:query])
      
    for grp in company_grps
      json_arr <<  grp.name
    end
      
    json_string = ""
    if not json_arr.blank?
      json_string = "'" + json_arr.uniq.join("','") + "'"
    end
      
    render :json => "{query:'#{params[:query]}' ,suggestions:[ " + json_string + "]}"
    return
  end
  
  def update_role_image
    job = Job.where(params[:job_id])
    x_score,y_score = job.role_score
    image_name = RoleQuestion.image_by_score(x_score,y_score)
    render :text=> image_name
    return
  end
   
  def work_image_color_desc
    @img_section = params[:img_msg]
  end
   
  def role_image_color_desc
    @img_section = params[:img_msg]
  end
   
  def birkman_msg
  end
   
  def all_color_employer
  end
   
  def work_birkman_msg
  end
   
  def role_birkman_msg
  end
   
  def employer_about_hilo
   
  end
    
  def employer_contact
      
  end
    
  def employer_terms_use
      
  end
    
  def employer_privacy
      
  end

  def street_address_handler
    require 'geocoder'
    @result = Geocoder.search(params[:company_street_one])
    if !@result.first.nil?
    end
    render 'street_address_handler', :formats => [:js]
    return
  end
    
  def geocode_fetch_for_employer
    require 'geocoder'
    @result = Geocoder.search(params[:company_city])
    if !@result.first.nil?
    end
    render 'geocode_fetch_for_employer', :formats => [:js]
    return
  end

  def geocode_fetch_for_cs
    require 'geocoder'
    @result = Geocoder.search(params[:cs_city])
    if !@result.first.nil?
    end
    render 'geocoder_basics', :formats=>[:js]
    return
  end

  def cs_new_city_fetch
    require 'geocoder'
    @result = Geocoder.search(params[:job_seeker_city]) unless params[:job_seeker_city].nil?
    render 'geocoder_cs_new', :formats=>[:js]
    return
  end

  def cs_search_city_fetch
    require 'geocoder'
    @result = Geocoder.search(params[:job_seeker_city]) unless params[:job_seeker_city].nil?
    render 'cs_search_city_fetch', :formats=>[:js]
    return
  end

  def geocode_fetch_for_employer_payment
    require 'geocoder'
    @result = Geocoder.search(params[:city])
    render 'geocoder_employer_payment', :formats=>[:js]
    return
  end

  def capture_log
    LogShare.log_job(params[:job_id], params[:platform_id], params[:job_seeker_id])
    render :text => "Logged"
  end

  def job_seeker_email
    if !session[:job_seeker].nil?
      LogShare.log_job(params[:job_id],params[:platform_id],session[:job_seeker].id)
      render :text => "Logged"
    end
  end
    
  def get_universities
    json_arr = []
    conditions = "activated = 1"
    universities = University.where("(#{conditions}) AND institution like ?","%" + params[:query] + "%").limit(50).all
    for university in universities
      json_arr << university.institution
    end
    
    json_string = ""
    if not json_arr.blank?
      json_string = "'" + json_arr.uniq.join("','") + "'"
    end
      
    render :json => "{query:'#{params[:query]}' ,suggestions:[ " + json_string + "]}"
    return
  end

  def credit_history
    @credit_list = PromotionalCode.where(:job_seeker_id=>session[:job_seeker].id).order("updated_at DESC").all
    render 'credit_history', :formats=>[:js]
  end

  def payment_history
    @payment_list = Payment.where(:job_seeker_id=>session[:job_seeker].id).order("created_at DESC").all
    render 'payment_history', :formats=>[:js]
  end

  def payment_history_emp
    reload_employer_session
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @payment_list = Payment.where("employer_id IN (#{condition})").order("created_at DESC").all
    render 'payment_history_emp', :formats=>[:js]
  end

  def employer_account
    @employer = Employer.where(:id => session[:employer].id).first
    @company_info = Company.select("companies.*, e.completed_registration_step").joins("INNER JOIN employers e ON companies.id = e.company_id").where("e.id = #{@employer.id}").first
    @old_payment_obj, @promo_code_obj = Payment.employer_old_payment_obj(@employer.id,false)
    render :partial=>"shared/employer/employer_account"
  end
  
  def user_admin
    reload_employer_session
    @emp_children = session[:employer].children
    render :partial=>"shared/employer/user_admin"
  end

  def fetch_children
    reload_employer_session
    emp = Employer.find(session[:employer].id)
    @children = emp.children
    if !@children.blank?
      render :partial=>"/employer_account/children", :collection=>@children, :as=>:c
    else
      render :text=>""
    end
  end

  def user_admin_tab2
    reload_employer_session
    @children = session[:employer].children
    render :partial=>"shared/employer/user_admin_tab2"
  end
  
  def user_admin_tab3
    reload_employer_session
    @tree = session[:employer].subtree.arrange
    @tree_ids = parse_tree(session[:employer].root.subtree.arrange)
    render :partial=>"shared/employer/user_admin_tab3"
  end

  def add_new_user
    reload_employer_session
    @employer = Employer.new
    render :partial=>"shared/employer/new_user_admin_boxes"
  end

  def add_group
    reload_employer_session
    case params[:emp].to_i
    when 0
      emp_id = session[:employer].id
      @employer_category = Employer.select("company_groups.name as name,company_groups.deleted as deleted").where("employers.id = #{emp_id} and company_groups.deleted = 0").joins("join companies on employers.company_id = companies.id join company_groups on employers.id = company_groups.employer_id").all
      is_added_by_parent = false
    else
      emp_id = params[:emp].to_i
      emp = Employer.find(params[:emp].to_i)
      ancestors = emp.ancestor_ids.join(",")
      subtree = emp.subtree_ids.join(",")
      @employer_category = Employer.select("company_groups.name as name,company_groups.deleted as deleted").where("employers.id IN (#{subtree}) and employers.id NOT IN (#{ancestors}) and company_groups.deleted = 0").joins("join companies on employers.company_id = companies.id join company_groups on employers.id = company_groups.employer_id").all
      is_added_by_parent = true
    end

    @cg = CompanyGroup.create(:name=>params[:name].to_s.strip, :company_id=>Employer.find(emp_id).company_id, :employer_id=>Employer.find(emp_id).id)
    if is_added_by_parent == true
      EmployerAlert.create!(:purpose => "folder-create", :read => false, :employer_id => Employer.find(emp_id).id, :employer_job_activity => session[:employer].id, :company_group_id => @cg.id)
    end

    case params[:sel].to_i
    when -1 #all positions
      @selected_category_size = 0
      session[:employer].subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      ancestors = session[:employer].ancestor_ids
      subtree = session[:employer].subtree_ids
      @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
    when 0 #my positions
      @selected_category_size = session[:employer].company_groups.where(:deleted=>false).size
      ancestors = session[:employer].ancestor_ids
      descendants = session[:employer].descendant_ids
      @jobs = session[:employer].get_my_positions(ancestors, descendants)
    else
      sl_emp = Employer.find(params[:sel].to_i)
      @selected_category_size = 0
      sl_emp.subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      ancestors = sl_emp.ancestor_ids
      subtree = sl_emp.subtree_ids
      arr = sl_emp.last_name.split""
      str_new = arr[0] + "."
      @name = sl_emp.first_name + " " + str_new
      @jobs = sl_emp.get_jobs_with_group(ancestors, subtree)
    end
    
    @current_employer= Employer.where("id=?", session[:employer].id).first
    @all_jobs_size = Job.where("employer_id IN (#{session[:employer].subtree_ids.join(',')}) and deleted=?", false).all.size
    @employer_category_size = session[:employer].company_groups.where(:deleted=>false).size
    render 'add_group', :format => [:js], :layout => false
  end

  def fetch_my_positions
    reload_employer_session
    ancestors = session[:employer].ancestor_ids
    descendants = session[:employer].descendant_ids
    @pos = 0
    case  params[:controller_name]
    when 'employer_account'
      get_pos_profile_chart_data(@pos)
      if params[:action_name]=="recruiting_manager"
        recruiting_manager_chat_data(@pos)
      end
    when 'position_profile'
      if params[:action_name] == 'xref'
        session[:selected] = @pos
        get_xref_pool_chart(@pos)
      end
    when 'postings'
    end
    @jobs = session[:employer].get_my_positions(ancestors, descendants)
    @selected_category_size = session[:employer].company_groups.where(:deleted=>false).size
    render 'fetch_my_positions', :format => [:js], :layout => false
    return
  end

  def fetch_all_positions
    reload_employer_session
    ancestors = session[:employer].ancestor_ids
    subtree = session[:employer].subtree_ids
    @pos = -1
    @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
    @selected_category_size = 0
    Employer.find(session[:employer].id).subtree.each do |emp|
      @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
    end
    #put this under if conditions
    case  params[:controller_name]
    when 'employer_account'
      get_pos_profile_chart_data(@pos)
      if params[:action_name]=="recruiting_manager"
        recruiting_manager_chat_data(@pos)
      end
    when 'position_profile'
      if params[:action_name] == 'xref'
        session[:selected] = @pos
        get_xref_pool_chart(@pos)
      end
    when 'postings'
    end
    render 'fetch_my_positions', :format => [:js], :layout => false
    return
  end

  def fetch_employer_position
    reload_employer_session
    emp = Employer.find_by_id(params[:id])
    ancestors = emp.ancestor_ids
    subtree = emp.subtree_ids
    @pos = params[:id]
    @jobs = emp.get_jobs_with_group(ancestors, subtree)
    @selected_category_size = 0
    emp.subtree.each do |e|
      @selected_category_size = @selected_category_size + e.company_groups.where(:deleted=>false).size
    end
    arr = emp.last_name.split""
    str_new = arr[0] + "."
    @name = emp.first_name + " " + str_new
    #put this under if conditions
    case  params[:controller_name]
    when 'employer_account'
      get_pos_profile_chart_data(@pos)

      if params[:action_name]=="recruiting_manager"
        recruiting_manager_chat_data(@pos)
      end

    when 'position_profile'
      if params[:action_name] == 'xref'
        session[:selected] = @pos
        get_xref_pool_chart(@pos)
      end
    when 'postings'
    end
    render 'fetch_my_positions', :format => [:js], :layout => false
    return
  end

  def category_reassign
    case params[:new_emp_id].to_i
    when 0
      new_emp_id = session[:employer].id
    else
      new_emp_id = params[:new_emp_id].to_i
    end
    cg = CompanyGroup.find(params[:cat_id].to_i)
    old_employer_id = cg.employer_id
    cg.employer_id = new_emp_id
    cg.sort_index = cg.id
    cg.save(:validate=>false)
    EmployerAlert.create!(:purpose => "folder-reassign", :read => false, :employer_id => old_employer_id, :employer_job_activity => session[:employer].id, :company_group_id => cg.id)

    params[:job_ids].split(",").each do |j|
      job = Job.find(j.to_i)
      job.employer_id = new_emp_id
      job.sort_index = job.id
      job.save(:validate=>false)
    end

    #left menu changes and chart data

    case params[:sel].to_i
    when -1
      @selected_category_size = 0
      Employer.find(session[:employer].id).subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      ancestors = session[:employer].ancestor_ids
      subtree = session[:employer].subtree_ids
      ##
      @pos = -1
      @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)
        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
      ##
    when 0 #my positions
      @selected_category_size = session[:employer].company_groups.where(:deleted=>false).size
      ancestors = session[:employer].ancestor_ids
      descendants = session[:employer].descendant_ids
      @jobs = session[:employer].get_my_positions(ancestors, descendants)
      ##
      @pos = 0
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)
        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
      ##
    else
      sl_emp = Employer.find(params[:sel].to_i)
      @selected_category_size = 0
      sl_emp.subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      ancestors = sl_emp.ancestor_ids
      subtree = sl_emp.subtree_ids
      arr = sl_emp.last_name.split""
      str_new = arr[0] + "."
      @name = sl_emp.first_name + " " + str_new
      @jobs = sl_emp.get_jobs_with_group(ancestors, subtree)

      ##
      @pos = params[:sel].to_i
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)

        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
      ##
    end

    @current_employer= Employer.where("id=?", session[:employer].id).first
    @all_jobs_size = Job.where("employer_id IN (#{session[:employer].subtree_ids.join(',')}) and deleted=?", false).all.size
    @employer_category_size = session[:employer].company_groups.where(:deleted=>false).size
    render 'reassign', :format => [:js], :layout => false
  end

  def refresh_left_menu
    case params[:sel].to_i
    when -1 #all positions
      @selected_category_size = 0
      Employer.find(session[:employer].id).subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      ancestors = session[:employer].ancestor_ids
      subtree = session[:employer].subtree_ids
      @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      @pos = -1
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)
        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
    when 0 #my positions
      @selected_category_size = session[:employer].company_groups.where(:deleted=>false).size
      ancestors = session[:employer].ancestor_ids
      descendants = session[:employer].descendant_ids
      @jobs = session[:employer].get_my_positions(ancestors, descendants)
      @pos = 0
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)
        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
    else
      sl_emp = Employer.find(params[:sel].to_i)
      @selected_category_size = 0
      sl_emp.subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      ancestors = sl_emp.ancestor_ids
      subtree = sl_emp.subtree_ids
      arr = sl_emp.last_name.split""
      str_new = arr[0] + "."
      @name = sl_emp.first_name + " " + str_new
      @jobs = sl_emp.get_jobs_with_group(ancestors, subtree)
      @pos = params[:sel].to_i
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)

        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
    end

    @current_employer= Employer.where("id=?", session[:employer].id).first
    @all_jobs_size = Job.where("employer_id IN (#{session[:employer].subtree_ids.join(',')}) and deleted=?", false).all.size
    @employer_category_size = session[:employer].company_groups.where(:deleted=>false).size
    render 'reassign', :format => [:js], :layout => false
  end

  def position_reassign
    #    case params[:new_emp_id].to_i
    #    when 0
    #      new_emp_id = session[:employer].id
    #    else
    #      new_emp_id = params[:new_emp_id].to_i
    #    end
    job = Job.find(params[:job_id].to_i)
    @employer_id = job.employer_id
    job.company_group_id = params[:new_cat_id].to_i
    job.employer_id = job.company_group.employer_id
    job.old_employer_id = @employer_id
    job.sort_index = job.id
    job.save(:validate=>false)

    EmployerAlert.create!(:job_id => job.id, :purpose => "job-re-assign", :read => false, :employer_id => @employer_id, :employer_job_activity => session[:employer].id)

    #left menu changes and chart data
    case params[:sel].to_i
    when -1 #all positions
      @selected_category_size = 0
      Employer.find(session[:employer].id).subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      ancestors = session[:employer].ancestor_ids
      subtree = session[:employer].subtree_ids
      @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      @pos = -1
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)
        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
    when 0 #my positions
      @selected_category_size = session[:employer].company_groups.where(:deleted=>false).size
      ancestors = session[:employer].ancestor_ids
      descendants = session[:employer].descendant_ids
      @jobs = session[:employer].get_my_positions(ancestors, descendants)
      @pos = 0
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)
        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
    else
      sl_emp = Employer.find(params[:sel].to_i)
      @selected_category_size = 0
      sl_emp.subtree.each do |emp|
        @selected_category_size = @selected_category_size + emp.company_groups.where(:deleted=>false).size
      end
      ancestors = sl_emp.ancestor_ids
      subtree = sl_emp.subtree_ids
      arr = sl_emp.last_name.split""
      str_new = arr[0] + "."
      @name = sl_emp.first_name + " " + str_new
      @jobs = sl_emp.get_jobs_with_group(ancestors, subtree)
      @pos = params[:sel].to_i
      case  params[:controller_name]
      when 'employer_account'
        get_pos_profile_chart_data(@pos)

        if params[:action_name]=="recruiting_manager"
          recruiting_manager_chat_data(@pos)
        end
      when 'position_profile'
        if params[:action_name] == 'xref'
          session[:selected] = @pos
          get_xref_pool_chart(@pos)
        end
      when 'postings'
      end
    end

    @current_employer= Employer.where("id=?", session[:employer].id).first
    @all_jobs_size = Job.where("employer_id IN (#{session[:employer].subtree_ids.join(',')}) and deleted=?", false).all.size
    @employer_category_size = session[:employer].company_groups.where(:deleted=>false).size
    render 'reassign', :format => [:js], :layout => false
  end
  
  def populate_user_folders
    reload_employer_session
    case params[:emp].to_i
    when 0
      ancestors = session[:employer].ancestor_ids
      descendants = session[:employer].descendant_ids
      @jobs = session[:employer].get_my_positions(ancestors, descendants)
      @dd = params[:dd]
    else
      emp = Employer.find(params[:emp].to_i)
      ancestors = emp.ancestor_ids
      subtree = emp.subtree_ids
      @jobs = emp.get_jobs_with_group(ancestors, subtree)
      @dd = params[:dd]
    end
    render :partial=>'shared/employer/folder_list'
  end

  def add_new_folder
    render :partial=>'shared/employer/add_new_folder'
  end
  
  def team_map_fullscreen
    reload_employer_session
    @tree = session[:employer].subtree.arrange
    @current_team_tree_ids = parse_tree(session[:employer].root.subtree.arrange)
    render :partial=>'shared/employer/team-map-full-screen'
  end
  def update_team_map
    reload_employer_session
    employer_source = Employer.find_by_id(params[:source_id])
    employer_target = Employer.find_by_id(params[:target_id])
    @current_team_tree_ids = parse_tree(session[:employer].root.subtree.arrange)
    unless @current_team_tree_ids == params[:current_team_tree_ids]
      render 'update_team_map_error', :format => [:js], :layout => false
      return
    end
    if employer_source.parent != employer_target

      #Allocate back unspent spending limit to parent if parent has a spending limit or else it's not required
      if employer_source.parent.spending_flag
        allocate_spent_spending_limit(employer_source, employer_source.parent)
        employer_source_descendants = employer_source.descendants
        employer_source_descendants.each do |child|
          allocate_spent_spending_limit(child, employer_source.parent)
        end
      end
      
      # Reset spending limit
      if employer_target.spending_flag
        employer_source.spending_flag = true
        employer_source.monthly_renew_flag = employer_target.monthly_renew_flag
        SpendingLimit.create(:employer_id=>employer_source.id,:spend_limit=>0,:available_balance=>0,:setter_id=>session[:employer].id)
        employer_source_descendants = employer_source.descendants
        employer_source_descendants.each do |child|
          child.spending_flag = true
          child.monthly_renew_flag = employer_target.monthly_renew_flag
          child.save(:validate=>false)
          SpendingLimit.create(:employer_id=>child.id,:spend_limit=>0,:available_balance=>0,:setter_id=>session[:employer].id)
        end
      else
        employer_source.spending_flag = false
        employer_source.monthly_renew_flag = false
        employer_source_descendants = employer_source.descendants
        employer_source_descendants.each do |child|
          child.spending_flag = false
          child.monthly_renew_flag = false
          child.save(:validate=>false)
        end
      end

      # Change the parent
      employer_source.parent = employer_target
      employer_source.save!(:validate=>false)
      reload_employer_session
      @current_team_tree_ids = parse_tree(session[:employer].root.subtree.arrange)
      render 'update_team_map', :format => [:js], :layout => false
    else
      render :text => 'nothing to do'
    end
    
  end

  def allocate_spent_spending_limit(employer, parent)
    if employer.spending_flag
      source_spending_limit = employer.spending_limits.last
      unless source_spending_limit.nil?
        parent_spending_limit = parent.spending_limits.last
        unless parent_spending_limit.nil?
          parent_spending_limit.available_balance = parent_spending_limit.available_balance + source_spending_limit.available_balance
          parent_spending_limit.spend_limit = parent_spending_limit.spend_limit + source_spending_limit.spend_limit
          parent_spending_limit.save(:validate=>false)
        end
      end
    end
  end

  def suspend_user
    emp = Employer.find_by_id(params[:user_id])
    emp.suspend_tree(emp.id, request.env["HTTP_HOST"])
    render :text => "Done"
  end

  def reinstate_user
    emp = Employer.find_by_id(params[:user_id])
    emp.reinstate_nodes(emp.id, request.env["HTTP_HOST"])
    render :text => "Done"
  end

  def delete_user
    emp = Employer.find_by_id(params[:user_id])
    @children_ids = emp.child_ids
    emp.delete_node_and_reassign(emp.id, session[:employer].id, request.env["HTTP_HOST"])
  end

  def add_deleted_children
    @children_ids = params[:children_ids].split","
  end

  def limit_crossed_check
    @emp = Employer.find_by_id(params[:user_id])
    @amt = params[:amount].delete"$"
    if params[:error_id] != "undefined"
      emp = Employer.find_by_id(params[:error_id])
      @emp_spend_limit = Employer.subtree_total_spend_limit(emp)
    end
    @value = @emp.spending_limit_crossed(@emp.id, @amt, session[:employer].id)
  end

  def create_new_user
    reload_employer_session
    @job_seeker = JobSeeker.where(:email=>params[:employer][:email]).first
    @employer = Employer.where(:email=>params[:employer][:email],:deleted=>false).first
    if !@employer.nil? or !@job_seeker.nil?
      render 'existing_new_user', :format => [:js], :layout => false
    else
      #Create the user
      @employer = Employer.new
      @employer.first_name = params[:employer][:first_name]
      @employer.last_name = params[:employer][:last_name]
      @employer.company_id = session[:employer].company_id
      @employer.email = params[:employer][:email]
      @employer.contact_email = params[:employer][:email]
      @employer.preferred_contact = 'contact_email'
      @employer.completed_registration_step = 2
      @employer.activated = true
      @employer.account_type_id = 2
      @employer.parent = session[:employer]
      @generate_password = Employer.generate_random_password
      @employer.password = @generate_password
      @employer.save!(:validate=>false)
      #Check parent and set default spending limits if any
      if(session[:employer].spending_flag == true)
        @employer.spending_flag = true
        SpendingLimit.create(:employer_id=>@employer.id,:spend_limit=>0,:available_balance=>0,:setter_id=>session[:employer].id)
      end
      if(session[:employer].monthly_renew_flag == true)
        @employer.monthly_renew_flag = true
      end
      @employer.save!(:validate=>false)
      #Notify the user
      @sender_name = session[:employer].first_name+" "+session[:employer].last_name
      Notifier.welcome_new_sub_user(@employer.email, @generate_password, request.env["HTTP_HOST"],@sender_name).deliver
      render 'create_new_user', :format => [:js], :layout => false
    end
  end

  def validate_new_user
    if session[:employer].nil?
      render :text => "Access Denied"
    elsif session[:employer].account_type_id == 3
      render :text => "Access Denied"
    else
      if params[:employer][:first_name].nil? or params[:employer][:last_name].nil? or params[:employer][:email].nil?
        render 'incomplete_new_user', :format => [:js], :layout => false
      else
        if params[:employer][:first_name]=="First Name" or params[:employer][:last_name]=="Last Name" or params[:employer][:email]=="Email"
          render 'incomplete_new_user', :format => [:js], :layout => false
        end
      end
    end
  end

  def elp_show_video
    @video_id = params[:id]
    render :partial => "/employer/landing/video_popup"
  end

  def elp_show_pdf
    @pdf_id = params[:id]
    render :partial => "/employer/landing/pdf_popup"
  end

  def save_cover_note
    cover_note = params[:cover_note].strip
    job_id = params[:job_id]

    unless session[:job_seeker].nil?
      job_status = JobStatus.where(:job_id=>job_id,:job_seeker_id=>session[:job_seeker].id).first
      unless job_status.nil?
        unless cover_note.blank?
          cover_note = truncate(cover_note, :length => 550) if cover_note.length > 550
          job_status.update_column(:cover_note,cover_note)
          render :text => "saved"
          return
        end
      end
    end

    render :text => "error"
    return
  end

  def view_cover_note
    session[:cover_note_job_id] = params[:job_id]
    job_seeker_id = params[:job_seeker_id]
    unless session[:cover_note_job_id].nil?
      @job_status_cover_note = JobStatus.where(:job_id=>session[:cover_note_job_id],:job_seeker_id=>job_seeker_id).first
      @job_cover_note = Job.find_by_id(session[:cover_note_job_id])
      @job_seeker = JobSeeker.find_by_id(job_seeker_id)
      render :partial => "/employer_account/cover_letter"
      return
    end
    render :text => "error"
  end

  def delete_confirmation_employer
    @children = session[:employer].children
  end

  def continue_delete_confirmation
    js = JobSeeker.find_by_id(session[:job_seeker].id)
    js.request_deleted = true
    js.save(:validate => false)
    Notifier.admin_delete_notification('job_seeker', js, request.env["HTTP_HOST"]).deliver
    render 'logout_user', :format => [:js], :layout => false
  end

  def continue_delete_confirmation_employer
    emp = Employer.find_by_id(session[:employer].id)
    if params[:set_field] == "yes"
      if params[:nominated_emp_id] != "undefined"
        if (Employer.find_by_id(params[:nominated_emp_id].to_i).request_deleted)
          render 'delete_yes_cant_nominated', :format => [:js], :layout => false
          return
        end
      end
      emp.request_deleted = true
      emp.nominated_employer_id = params[:nominated_emp_id].to_i
      if params[:nominated_emp_id].to_i == 0
        emp.nominated_employer_id = nil
      end
      emp.save(:validate => false)
    elsif params[:set_field] == "no"
      emp.subtree_ids.each do |emp_id|
        emp_child = Employer.find_by_id(emp_id)
        if emp_child.request_deleted
          emp_child.deleted = true
        end
        emp_child.request_deleted = true
        emp_child.save(:validate => false)
      end
    end
    Notifier.admin_delete_notification('employer', emp, request.env["HTTP_HOST"]).deliver
    render 'logout_user', :format => [:js], :layout => false
  end

  def show_hilo_search_work_env
    render '/hilo_search/save_employer_work_env_questions', :format => [:js], :layout => false
  end

  def duplicate_job
    @job = Job.find_by_id(params[:job_id])
    unless @job.nil?
      ## Duplicates
      # 1. Position Type
      # 2. Pairing Logic Values
      # 3. Certificates and Licenses
      # 4. Languages
      # 5. Work Environment & Role + Question & Answers
      # 6. Daily Responsibilities
      @duplicate_job = @job.dup :include => [:job_criteria_desired_employments, :job_criteria_certificates, :job_criteria_languages, :job_workenv_questions, :job_role_questions, :job_profile_responsibilities]
      @duplicate_job.name << " (copy)"
      @duplicate_job.code = nil
      @duplicate_job.detail_preview = false
      @duplicate_job.overview_complete = false
      @duplicate_job.profile_complete = false
      @duplicate_job.active = false
      @duplicate_job.save!(:validate => false)
      # Reorder jobs in the folder so that the duplicate job is just below it
      sort_index = []
      folder = CompanyGroup.find_by_id(@job.company_group_id)
      jobs_in_folder = folder.jobs.where(:deleted=>false).order("sort_index ASC").all
      #jobs_in_folder = Job.find_by_sql("SELECT `jobs`.* FROM `jobs` WHERE `jobs`.`company_group_id` = #{@job.company_group_id} AND `jobs`.`deleted` = 0 AND (`jobs`.`deleted_at` IS NULL) ORDER BY sort_index ASC")
      jobs_in_folder.delete_at(jobs_in_folder.index{|x| x.id == @duplicate_job.id})
      jobs_in_folder.insert(jobs_in_folder.index{|x| x.id == @job.id}+1,@duplicate_job)
      jobs_in_folder.each do |job|
        sort_index.push(job.sort_index)
      end
      sort_index.sort!
      index = 0
      jobs_in_folder.each do |job|
        job.sort_index = sort_index[index]
        job.save!(:validate=>false)
        index = index + 1
      end
      ## Duplicate (left over items)
      # 7. Roles
      # 8. Desired Education
      # 9. Preferred Colleges and Universities
      # 10. Attachments
      @job.added_roles.each do |role|
        @duplicate_job.added_roles << role.dup
      end
      @job.added_universities.each do |university|
        @duplicate_job.added_universities << university.dup
      end
      @job.added_degrees.each do |degree|
        @duplicate_job.added_degrees << degree.dup
      end
      @job.job_attachments.each do |job_attachment|
        begin
          obj = @duplicate_job.job_attachments.new
          obj.attachment = job_attachment.attachment
          obj.attachment_title = job_attachment.attachment_title
          obj.save!(:validate => false)
        rescue  
        end
      end
      # Refresh left menu & related items
      if params[:parent_id].present?
        case params[:parent_id].to_i
        when -1
          ancestors = session[:employer].ancestor_ids
          subtree = session[:employer].subtree_ids
          @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
        when 0
          ancestors = session[:employer].ancestor_ids
          descendants = session[:employer].descendant_ids
          @jobs = session[:employer].get_my_positions(ancestors, descendants)
        else
          sl_emp = Employer.find(params[:parent_id].to_i)
          ancestors = sl_emp.ancestor_ids
          subtree = sl_emp.subtree_ids
          @jobs = sl_emp.get_jobs_with_group(ancestors, subtree)
        end
      else
        ancestors = session[:employer].ancestor_ids
        subtree = session[:employer].subtree_ids
        @jobs = session[:employer].get_jobs_with_group(ancestors, subtree)
      end
      # To open the folder the job exist in
      @copied_job_id = @job.id
      # Leaving @job set will highlight that job in the left menu
      if params[:current_job_flag] == "false"
        @job = nil
      end
    end
  end

  private

  def parse_tree(node,tree_ids = "")
    node.each_pair do |k,v|
      tree_ids = tree_ids + k.id.to_s + ","
      if !v.blank?
        tree_ids = parse_children(v,tree_ids)
      end
    end
    return tree_ids
  end

  def parse_children(node,tree_ids)
    node.each_pair do |k,v|
      tree_ids = tree_ids + k.id.to_s + ","
      if !v.blank?
        tree_ids = parse_children(v,tree_ids)
      end
    end
    return tree_ids
  end
  
  def validate_job_for_employer
    @job = Job.where("jobs.id = ? and jobs.employer_id = ? and jobs.deleted = ?", params[:job_id], session[:employer].id, false).first
    if @job.blank?
      render :text =>"unauthorized"
      return false
    end
  end

end