# coding: UTF-8

class PairingProfileController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  layout "registration"
  
  before_filter :required_loggedin_job_seeker, :except => [:career_paths, :desired_roles, :role_description, :search_roles, :open_role_explorer, :auto_select_cluster_and_path]
  before_filter :validate_personality_step,:only=>[:personality]
  before_filter :validate_basics_step,:only=>[:basics]
  before_filter :validate_credentials_step,:only=>[:credentials]
  
  def basics
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
    @selected_employment_ids  = @job_seeker.job_seeker_desired_employments.map{|j| j.desired_employment_id}
    @selected_location_ids  = @job_seeker.job_seeker_desired_locations.map{|j| j.desired_location_id}
    @location = @job_seeker.job_seeker_desired_locations.first
        
    #if !@location.nil?
    #  latitude = @location.latitude
    #  longitude = @location.longitude
    #  require 'geocoder'
    #  @location = Geocoder.search(latitude, longitude)
    #end
        
    #if @location[0] != nil
    #  @pincode = @pincode[0].pincode
    #  if @pincode == nil
    #    @pincode = ""
    #  end
    #end
        
    @compensation_range = $compensation_values
    #@paidtime_range = $desired_paid_time
    #@commute_range = $desired_commute_radius
    @desired_employments = DesiredEmployment.find(:all)
    @desired_locations = DesiredLocation.find(:all)
  end

  def set_adv_pop_flag
    @js = JobSeeker.where("id=?", session[:job_seeker].id).first
    if @js.advanced_alert == false
      @js.advanced_alert = true
    else
      @js.advanced_alert = false
    end
    @js.save(:validate => false)
    reload_seeker_session(@js)
    render :text => "DONE"
  end

  def get_adv_pop_flag
    @js = JobSeeker.where("id=?", session[:job_seeker].id).first
    render :text => @js.advanced_alert
  end
  
  def save_basics
    if not request.post?
      redirect_to :controller => :pairing_profile,:action=>:basics
      return
    end
      
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
      
    #@job_seeker.desired_commute_radius = params[:desired_commute_value]
    #@job_seeker.desired_paid_offs = params[:desired_paidtime_value]
      
    @job_seeker.minimum_compensation_amount = params[:compensation_value_min]
    @job_seeker.maximum_compensation_amount = params[:compensation_value_max]
    if !params[:save_type].blank? and params[:save_type] == "credentials"
      @job_seeker.completed_registration_step = PAIRING_BASICS_STEP
    end
    add_remove_desired_employment
    add_remove_desired_location

    @job_seeker.save(:validate => false)
    reload_seeker_session()

    if !params[:save_type].blank? and params[:save_type] == "credentials"
      redirect_to :controller => :payment
      return
    elsif !params[:save_type].blank? and params[:save_type] == "update"
      if !@job_seeker.job_seeker_birkman_detail.grid_work_environment_x.nil?
        PairingLogic.delay(:priority=>2).pairing_value_job_seeker(@job_seeker)
      end
      render 'profile_basics_loader', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "profile.basics_loader"
      #      end
      return
    else
      redirect_to :controller => :login, :action=> :logout
      return
    end
  end
    
  def credentials
    @job_seeker = JobSeeker.where(:id=>session[:job_seeker].id).first
    @selected_certificates = NewCertificate.find_by_sql("SELECT `new_certificates`.`certification_name` as `name`, `job_seeker_certificates`.`order` as `order` FROM `new_certificates` INNER JOIN `job_seeker_certificates` ON `new_certificates`.`id` = `job_seeker_certificates`.`new_certificate_id` WHERE `job_seeker_certificates`.`job_seeker_id` = #{@job_seeker.id}")
    @selected_licenses = License.find_by_sql("SELECT `licenses`.`license_name` as `name`, `job_seeker_certificates`.`order` as `order` FROM `licenses` INNER JOIN `job_seeker_certificates` ON `licenses`.`id` = `job_seeker_certificates`.`license_id` WHERE `job_seeker_certificates`.`job_seeker_id` = #{@job_seeker.id}")
    temp_hash = {}
    @selected_certificates.each{|c|
      k = c.order
      v = c.name
      temp_hash.update({k=>v})
    }
    @selected_licenses.each{|c|
      k = c.order
      v = c.name
      temp_hash.update({k=>v})
    }
    @new_selected_certificates = []
    temp_hash.keys.sort.each{|c|
      @new_selected_certificates<<temp_hash[c]
    }
    @new_selected_certificates = @new_selected_certificates.map{|c| c}.join("_jucert_")

    @selected_colleges = University.find_by_sql("SELECT `universities`.`institution` as `name` FROM `universities` INNER JOIN `added_universities` ON `universities`.`id` = `added_universities`.`university_id` WHERE `added_universities`.`adder_id` = #{@job_seeker.id} AND `added_universities`.`adder_type` = 'JobSeeker'").map{|u| u.name}.join("_cscolg_")
    #@selected_proficiencies = @job_seeker.job_seeker_proficiencies.map{|a|  a.proficiency.name + "__" + a.education_id.to_s + "__" + a.skill_id.to_s}.join("_juskill_")
    @selected_languages = @job_seeker.job_seeker_languages.map{|lang| lang.language.name + "__" + lang.proficiency_val}.join(",")
    @selected_degree = Degree.find_by_sql("SELECT `degrees`.`name` as `name`, `added_degrees`.`degree_status` as `status` FROM `degrees` INNER JOIN `added_degrees` ON `degrees`.`id` = `added_degrees`.`degree_id` WHERE `added_degrees`.`adder_id` = #{@job_seeker.id} AND `added_degrees`.`adder_type` = 'JobSeeker'").map{|d| d.name+"__"+d.status}.join(",")
    #@selected_degree = @selected_degree.name+"__"+@selected_degree.degree_status
    if @selected_degree.empty?
      @selected_degree = "__"
    end
    @languages = Language.find(:all)
    @educations = EducationLevel.find(:all)
    @skills = SkillLevel.find(:all)
    @proficiencies = Proficiency.where("activated = ?", 1).all
    fetch_all_roles_for_logged_in_seeker
  end
   
  def save_credentials
    if not request.post?
      redirect_to :controller => :pairing_profile, :action => :save_credentials
      return
    end
    
    @job_seeker = JobSeeker.where(:id => session[:job_seeker].id).first
    
    if !params[:save_type].blank? and params[:save_type] == "complete"
      @job_seeker.completed_registration_step = PAIRING_CREDENTIALS_STEP
    end
    
    #@job_seeker.add_languages(create_language_hash(params[:selected_languages]))
    if !@job_seeker.id.nil? 
      # ************  SAVING CREDENTUIALS *****************
      
      #    COMMENTED as no longer requried 
      #    cert_names = params[:certificate_param].blank?  ? [] : params[:certificate_param].split("_jucert_")
      #    @job_seeker.add_certificates(cert_names,session[:job_seeker].id)
      #        
      #    skill = params[:skills].blank?  ? [] : params[:skills].split("_juskill_")
      #    @job_seeker.add_skills(skill,session[:job_seeker].id)
      
      #save LANGUAGES
      @job_seeker.add_languages_new(params[:selected_languages])
      
      if !params[:armed_forces].nil?
        @job_seeker.armed_forces = params[:armed_forces]
      end    
      
      #save DEGRESS   
      if(!params[:degree].nil? or !params[:status].nil?)
        AddedDegree.delete_all("adder_id = '#{@job_seeker.id}' and adder_type = 'JobSeeker'")
        if params[:degree] != "" and params[:status] != ""
          degree = Degree.find_by_name(params[:degree]).id

          @added_degree = AddedDegree.new(
            :adder_id => @job_seeker.id,
            :adder_type => "JobSeeker",
            :degree_status => params[:status],#save STATUS
            :degree_id => degree)
          @added_degree.save
        end
      end
      
      #save UNIVERSITY
      if !params[:universities].nil?
        AddedUniversity.delete_all("adder_id = '#{@job_seeker.id}' and adder_type = 'JobSeeker'")
        uni_arr = params[:universities].html_safe.split("_cscolg_")
        uni_arr.each{|uni|
          unless uni.blank?
            @uni = University.where(:institution => uni).first
            if !@uni.nil?
              #if unni exists
              added_university = AddedUniversity.new(:adder_id => @job_seeker.id, :adder_type => "JobSeeker", :university_id => @uni.id)
              added_university.save
            else
              #if uni doesnt exists
              @new_uni = University.new(:institution => uni, :activated=>false)
              if @new_uni.save
                added_university = AddedUniversity.new(:adder_id => @job_seeker.id, :adder_type => "JobSeeker", :university_id => @new_uni.id)
                added_university.save
              end
            end
          end
        }
      end
      
      #save LICENSES
      if !params[:certificate_param].nil?
        JobSeekerCertificate.delete_all("job_seeker_id = '#{@job_seeker.id}'")
        lic_arr = params[:certificate_param].html_safe.split("_jucert_")
        lic_arr.each_with_index{|lic, i|
          unless lic.blank?
            begin
              @certificate = NewCertificate.where(:certification_name => lic).first
              #NewCertificate.find_by_sql("SELECT `new_certificates`.`ID` as id FROM `new_certificates` WHERE (`Certification Name` like '#{lic}')")
              #NewCertificate.select("`ID` as id, `Certification Name` as name").where("`Certification Name` like ?",lic).first
              #Certificate.where(:certification_name => lic).first
              @license = License.where(:license_name => lic).first
              #License.select("`ID` as id, `License Name` as name").where("`License Name` like ?",lic).first
              #License.where(:license_name => lic).first
              if !@certificate.nil?
                #if cert is not nil
                job_seeker_certificate = JobSeekerCertificate.new(:job_seeker_id => @job_seeker.id, :new_certificate_id => @certificate.id, :order=>i+1)
                job_seeker_certificate.save
              elsif !@license.nil?
                #if licenese is not  nil
                job_seeker_certificate = JobSeekerCertificate.new(:job_seeker_id => @job_seeker.id, :license_id => @license.id, :order=>i+1)
                job_seeker_certificate.save
              else
                #if lic and cert both are nil
                @new_cert =  NewCertificate.create(:occupation=>"", :sub_occupation=>"", :certification_name=>lic, :certifying_organization=>"", :certification_description=>"", :source_url=>"", :activated=>false)
                #ActiveRecord::Base.connection.execute("INSERT INTO `new_certificates`(`Occupation`, `Sub-Occupation`, `certification_name`, `Certifying Organization`, `Certification Description`, `Source URL`, `activated`) VALUES(' ', ' ', '#{lic}', ' ', ' ', ' ', 0)")
                #@new_cert = NewCertificate.where(:certification_name => lic).first
                #NewCertificate.select("`ID` as id, `certification_name` as `name`").where("`certification_name` like ?",lic).first
                job_seeker_certificate = JobSeekerCertificate.new(:job_seeker_id => @job_seeker.id, :new_certificate_id => @new_cert.id, :order=>i+1)
                job_seeker_certificate.save

              end
            rescue ActiveRecord::RecordNotFound
            end
          end
        }
      end
      
      #save ROLES
      AddedRole.delete_all("adder_id = '#{@job_seeker.id}' AND adder_type = 'JobSeeker'")
      if !params[:role_code].blank?
        role_1, role_2, role_3 = params[:role_code].split("_roles_array_")
        role_code_1, edu_level_1, exp_level_1 = role_1.split("_")
          
        edu_level_id = EducationLevel.where(:name => CGI::unescape(edu_level_1)).first.id
        exp_level_id = ExperienceLevel.where(:name => CGI::unescape(exp_level_1)).first.id
        AddedRole.create(:adder_id => @job_seeker.id, :adder_type => "JobSeeker", :code => role_code_1, :education_level_id => edu_level_id, :experience_level_id => exp_level_id)
        if !role_2.nil?
          role_code_2, edu_level_2, exp_level_2 = role_2.split("_")
          edu_level_id = EducationLevel.where(:name => CGI::unescape(edu_level_2)).first.id.to_i
          exp_level_id = ExperienceLevel.where(:name => CGI::unescape(exp_level_2)).first.id.to_i
          AddedRole.create(:adder_id => @job_seeker.id, :adder_type => "JobSeeker", :code => role_code_2, :education_level_id => edu_level_id, :experience_level_id => exp_level_id)
        end
        if !role_3.nil?
          role_code_3, edu_level_3, exp_level_3 = role_3.split("_")
          edu_level_id = EducationLevel.where(:name => CGI::unescape(edu_level_3)).first.id.to_i
          exp_level_id = ExperienceLevel.where(:name => CGI::unescape(exp_level_3)).first.id.to_i
          AddedRole.create(:adder_id => @job_seeker.id, :adder_type => "JobSeeker", :code => role_code_3, :education_level_id => edu_level_id, :experience_level_id => exp_level_id)
        end
      end
    else
      redirect_to :controller => :pairing_profile, :action => :save_credentials
      return
    end
    # ************  END SAVING CREDENTUIALS *****************
    
    @job_seeker.save(:validate => false)
    reload_seeker_session() # dont pass the @job_seeker object as the size is too big because of all relationship objects instead reload it fresh
    if !params[:save_type].blank? and params[:save_type] == "complete"
      redirect_to :controller => :pairing_profile,:action=>:basics
      #session[:military_popup]=true
      return
    elsif !params[:save_type].blank? and params[:save_type] == "update"
      if !@job_seeker.job_seeker_birkman_detail.grid_work_environment_x.nil?
        PairingLogic.delay(:priority=>2).pairing_value_job_seeker(@job_seeker)
      end
      render 'profile_credentials_loader', :formats=>[:js], :layout=>false
      #      render :update do |page|
      #        page.call "profile.credentials_loader"
      #      end
      return
    else
      #Notifier.email_save_and_return_later(@job_seeker, request.env["HTTP_HOST"]).deliver
      redirect_to :controller => :login, :action => :logout
      return
    end
  end

  def set_adv_pop_cookie
    cookies[:adv_pop] = session[:job_seeker].id
    render :text => "done"
  end

  def career_paths
    if !params[:code].blank?
      @career_cluster = CareerCluster.where("code = ?", params[:code]).first
    end
    @career_paths = CareerCluster.where(:career_cluster => params[:career_cluster]).select("DISTINCT career_cluster, pathway")

    respond_to do |format|
      format.html {render(:partial => 'career_paths')}
    end
  end

  def desired_roles
    @desired_roles = CareerCluster.where(:career_cluster => params[:career_cluster], :pathway => params[:pathway]).select("DISTINCT career_cluster, pathway, code, descripton")

    respond_to do |format|
      format.html {render(:partial => 'credential_desired_roles')}
    end
  end

  def role_description
    @role_description = OccupationData.where(:onetsoc_code => params[:career_code]).first
    @tasks = TaskStatement.where(:onetsoc_code => params[:career_code])
    @lay_title = LayTitle.all(:select => "lay_title", :conditions => ["onetsoc_code = ?", params[:career_code]])

    respond_to do |format|
      format.html {render(:partial => 'role_description')}
    end
  end

  def search_roles
    @order = params[:order]
    @desired_roles = Array.new
    query = strip_tags(params[:search_roles].gsub("'"," ").gsub("\""," "))
    unless query.blank?
      if @order.blank?
        search = OccupationData.search do
          fulltext query do
            minimum_match 1
          end
		  with :banned, false
          paginate :page => 1, :per_page => OccupationData.count
          order_by(:sort_title, :asc)
          order_by(:score, :desc)
        end
      elsif @order == "Role ASC, Score DESC"
        search = OccupationData.search do
          fulltext query do
            minimum_match 1
          end
		  with :banned, false
          paginate :page => 1, :per_page => OccupationData.count
          order_by(:sort_title, :asc)
          order_by(:score, :desc)
        end
      elsif @order == "Score ASC, Role DESC"
        search = OccupationData.search do
          fulltext query do
            minimum_match 1
          end
		  with :banned, false
          paginate :page => 1, :per_page => OccupationData.count
          order_by(:score, :desc)
          order_by(:sort_title, :asc)
        end
      end

      i = 0

      search.each_hit_with_result do |hit|
        @desired_roles<<search.results[i] if hit.score > (params[:sensitivity].blank? ? '5' : params[:sensitivity]).to_i/10.to_f
        i = i + 1
      end
    end

    if @order.blank?
      @order = nil
    elsif @order == "Role ASC, Score DESC"
      @order = "alphabetical"
    elsif @order == "Score ASC, Role DESC"
      @order = "relevance"
    end

    @searched_term = params[:search_roles].gsub('\\','')
    @sensitivity = params[:sensitivity].blank? ? '5' : params[:sensitivity]

    respond_to do |format|
      format.js { render 'search_results', :formats=>[:js], :layout=>false }
    end
  end

  def open_role_explorer
    @career_cluster = CareerCluster.where("code = ?", params[:career_cluster]).first
    @career_clusters = CareerCluster.select("DISTINCT career_cluster")

    respond_to do |format|
      format.html {
        render(:partial => 'open_role_explorer', :layout => false)
      }
    end
  end

  def auto_select_cluster_and_path
    @roles = CareerCluster.where("code = ?", "#{params[:career_code]}").select('career_cluster, pathway').uniq

    respond_to do |format|
      format.js { render 'highlight_results', :formats=>[:js] }
    end
  end
  
  private
  #~ def validate_personality_step
  #~ redirect_to(redirect_to_registration_step())  if session[:job_seeker].completed_registration_step.to_i != ACCOUNT_SETUP_STEP
  #~ end
  
  def validate_basics_step
    redirect_to redirect_to_registration_step() if session[:job_seeker].completed_registration_step.to_i != PAIRING_CREDENTIALS_STEP
  end
  
  def validate_credentials_step
    redirect_to redirect_to_registration_step() if session[:job_seeker].completed_registration_step.to_i != QUESTIONNAIRE_STEP
  end

  def fetch_all_roles_for_logged_in_seeker
    @job_seeker_added_roles = AddedRole.where("adder_id = ? AND adder_type = ?", @job_seeker.id, "JobSeeker")
    if !@job_seeker_added_roles[0].nil?
      @career_cluster_role1 = CareerCluster.where("code = ?", @job_seeker_added_roles[0].code).first
    end
    if !@job_seeker_added_roles[1].nil?
      @career_cluster_role2 = CareerCluster.where("code = ?", @job_seeker_added_roles[1].code).first
    end
    if !@job_seeker_added_roles[2].nil?
      @career_cluster_role3 = CareerCluster.where("code = ?", @job_seeker_added_roles[2].code).first
    end
  end
end