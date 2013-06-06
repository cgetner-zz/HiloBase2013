#coding: UTF-8
##--
#Important Note: This rake task is design to copy jobs xml from sftp server(ftp-del1.globallogic.com) and import jobs to the system.
#Author:###
##++

require 'net/sftp'
require 'countries'
include ActionView::Helpers::SanitizeHelper

namespace :sftp_xml do
  desc "Copy xml from ftp server to hilo."
  task(:data => :environment) do

    def copy_xml
      host = "ftp-del1.globallogic.com"
      user_name = "hilocli1"
      password = "H@i#l$o@G"

      remote_path = '/home/hilocli1/Aspen/'
      local_folder_name = "xml_downloads"
      local_path_to_folder = Rails.root.to_s + "/app/assets/#{local_folder_name}/"
      transferred_file_flag = false
      puts "Deleting files from #{local_path_to_folder}."
      Dir.chdir(local_path_to_folder)
      Dir.glob('*.*').each do|f|
        FileUtils.rm(f)
      end
      puts "Deleted all files from #{local_path_to_folder}."

      puts 'Connecting to remote server...'
      Net::SFTP.start(host, user_name, :password => password, :keys => []) do |sftp|
        FileUtils.mkdir_p(local_path_to_folder,:mode => 0777) unless File.exists?(local_path_to_folder)
        # list the entries in a directory, #  Iterate over the files.
        name_hash = {}
        sftp.dir.entries(remote_path).map {|entry|
          if entry.file?
            match = /.xml/.match(entry.name.split('_').last)
            if match
              name_hash.store(entry, entry.name)
            end
          end
        }

        temp_hash = Hash.new
        name_hash.sort_by {|k,v| v}.reverse.each{|k,v| temp_hash.store(k, v)}

        temp_hash.delete_if {|k,v|
          k.longname.squeeze(" ").split(" ")[4].eql? "0"
        }

        temp_hash.delete_if {|k,v|
          ["ibm", "accenture", "ernst_and_young", "ncaa"].include? v.split("_").reverse.drop(1).reverse.join("_")
        }

        temp = Array.new
        temp_hash.delete_if {|k,v|
          temp.include? v.split("_").first
          temp<<v.split("_").first
          temp.uniq!
        }

        unless temp_hash.blank?
          temp_hash.each do |entry|
            sftp.setstat("#{remote_path}#{entry.first.name}", :permissions => 0777)
            sftp.download!("#{remote_path}#{entry.first.name}", "#{local_path_to_folder}#{entry.first.name}")
            transferred_file_flag = true
          end
        end
      end
      puts "Disconnected from remote server..."

      if transferred_file_flag
        puts "File transfer complete."
        import_jobs()
      else
        puts "There is no file on server."
      end
    end

    def import_jobs
      require 'xml'
      require 'geocoder'

      ################### Configure the import ################################
      local_folder_name = "xml_downloads"
      local_path_to_folder = Rails.root.to_s + "/app/assets/#{local_folder_name}/"
      vendor_name = ''
      file_name = ''
      company_id_for_import = 1

      company = Company.find(company_id_for_import)
      @jobs_active_count = Hash.new
      @jobs_deleted_count = Hash.new
      @jobs_inactive_count = Hash.new
      @jobs_failed_count = Hash.new
      @job_count = 0

      Dir.chdir(local_path_to_folder)
      Dir.glob('*.*').each do|f|
        if File.basename(local_path_to_folder + f).include?("johnson_and_johnson") or File.basename(local_path_to_folder + f).include?("lockheed_martin") or File.basename(local_path_to_folder + f).include?("ibm") or File.basename(local_path_to_folder + f).include?("ernst_and_young") or File.basename(local_path_to_folder + f).include?("accenture") or File.basename(local_path_to_folder + f).include?("design_group") or File.basename(local_path_to_folder + f).include?("ncaa")
          vendor_name = "Aspen"
          file_name = f
          file_import(local_path_to_folder, file_name, vendor_name, company)
        end
      end

      p "@jobs_active_count :" + @jobs_active_count.to_s
      p "@jobs_deleted_count :" + @jobs_deleted_count.to_s
      p "@jobs_inactive_count :" + @jobs_inactive_count.to_s
      p "@jobs_failed_count :" + @jobs_failed_count.to_s
      p "@job_count :" + @job_count.to_s

      Notifier.send_summary(@jobs_active_count, @jobs_deleted_count, @jobs_inactive_count, @jobs_failed_count).deliver
    end

    def website_link link
      unless link.blank?
        website = link.split("//")
        unless (website[0] == "http:" or website[0] == "https:")
          link = "http://" + link.to_s
        end
      else
        link = nil
      end
      return link
    end

    def file_import(local_path_to_folder, file_name, vendor_name, company)
      @jobs_in_xml = Array.new
      @hiring_company_name = ""
      begin
        xml = File.read(local_path_to_folder + file_name)
        parser, parser.string = XML::Parser.new(xml), xml
        doc = parser.parse
      rescue
        return
      end

      doc.find('//jobs/job').each do |s|

        benchmark = Benchmark.measure {
          start_time = Time.now
          puts "Job Started at.... #{start_time}"
          job = Hash.new #save
          job_location = Hash.new #save
          job_criteria_desired_employments = Hash.new #save
          new_certificates = Hash.new
          licenses = Hash.new
          job_criteria_languages = Hash.new #save
          job_criteria_certificates = Hash.new #save
          added_degrees = Hash.new #save
          added_universities = Hash.new #save
          added_roles = Hash.new
          profile_responsibilities = Array.new
          proceed = true
          repeat_flag = false
          @hiring_company_name = s.find('hiring-company-name').first.content
          country = Country.find_country_by_name(s.find('job-location').first.find('country').first.content)
          if country.nil?
            country = Country.find_country_by_alpha2(s.find('job-location').first.find('country').first.content)
          end

          #create folder
          folder = CompanyGroup.find_by_sql("SELECT `company_groups`.* FROM `company_groups` WHERE (deleted = 0 and name like \"%#{@hiring_company_name}\" AND employer_id = #{company.employers.first.root_id}) ORDER BY created_at DESC LIMIT 1").last
          if folder.nil?
            folder = CompanyGroup.create(:name=>"%03d" % 1 + "-" + @hiring_company_name, :company_id=>company.id, :employer_id=>company.employers.first.root_id, :deleted=>false)
          else
            folder = CompanyGroup.create(:name=>"%03d" % (folder.name.split("-").first.to_i + 1) + "-" + @hiring_company_name, :company_id=>company.id, :employer_id=>company.employers.first.root_id, :deleted=>false) if folder.jobs.size >= 20
          end

          #job
          save_job = Time.now
          %w[armed-forces grid-work-environment-x grid-work-environment-y grid-work-role-x grid-work-role-y hiring-company hiring-company-name internal minimum-compensation-amount name remote-work summary website-one website-two website-three website-title-one website-title-two website-title-three job-link vendor-job-id].each do |a|
            job[a.gsub(/-/, "_")] = s.find(a).first.content
          end

          %w[job_link website_one website_two website_three].each do |l|
            unless job[l].blank?
              job[l] = website_link job[l]
            end
          end

          if job["minimum_compensation_amount"].empty?
            job["minimum_compensation_amount"] = 20
            job["maximum_compensation_amount"] = job["minimum_compensation_amount"] + 20
            job.merge!({"salary_not_disclosed"=>true})
          else
            job["minimum_compensation_amount"] = job["minimum_compensation_amount"].to_i/1000
            job["minimum_compensation_amount"] = job["minimum_compensation_amount"] - job["minimum_compensation_amount"] % 5
            job["minimum_compensation_amount"] = 20 if job["minimum_compensation_amount"] < 20
            job["maximum_compensation_amount"] = job["minimum_compensation_amount"] + 20
          end
          job.merge!({"hiring_company"=>false, "hiring_company_name"=>@hiring_company_name, "employer_id"=>company.employers.first.root_id, "company_id"=>folder.company_id, "company_group_id"=>folder.id})

          if @jobs_in_xml.include? job["vendor_job_id"]
            repeat_flag = true
          else
            @jobs_in_xml<<job["vendor_job_id"]
          end

          puts "time_taken_for_job_hash = #{Time.now - save_job}"

          #job-location
          job_location_time = Time.now
          %w[city country latitude longitude state street-one zip-code].each do |a|
            job_location[a.gsub(/-/, "_")] = s.find('job-location').first.find(a).first.content
            if a == 'street-one'
              job_location['street_one'] = "Not disclosed" if job_location['street_one'].empty?
            end
          end

          if job_location['city'].empty?
            job_location = {}
          else
            #city not empty
            if job_location['state'].empty?
              #state empty
              if job_location['country'].empty?
                job_location = {}
              end
            end
          end

          ###
          unless job_location.empty?
            begin
              result = Geocoder.search(job_location["street_one"] + ", " + job_location["city"] + ", " + job_location["state"] + ", " + job_location["country"])
            rescue
              sleep 1
              result = Geocoder.search(job_location["street_one"] + ", " + job_location["city"] + ", " + job_location["state"] + ", " + job_location["country"])
            end
            unless result.empty?
              unless result.first.nil?
                job_location['latitude'] = result.first.latitude
                job_location['longitude'] = result.first.longitude
                job_location['country'] = result.first.country
                country = Country.find_country_by_name(job_location['country'])
                job_location['state'] = result.first.state
              end
            else
              job_location = {}
            end
          else
          end
          ###

          puts "#{job_location.inspect}"
          puts "time_taken_for_job_location = #{Time.now - job_location_time}"

          #comparison
          compare = Job.find_by_sql("SELECT `jobs`.* FROM `jobs` WHERE (`jobs`.`deleted_at` IS NULL) AND (vendor_job_id like '#{job["vendor_job_id"]}')")
          unless compare.empty?
            j = compare.first
            proceed = false
          else
            j = Job.new
          end

          job_location_creation = Time.now
          unless job_location.empty?
            jl = JobLocation.create(job_location)
            job.merge!({"job_location_id"=>jl.id})
          end
          puts "job_location_creation time is : #{Time.now - job_location_creation}"

          if proceed
            j.attributes = job
          else
            j.name = job["name"]
            j.minimum_compensation_amount = job["minimum_compensation_amount"]
            j.maximum_compensation_amount = job["maximum_compensation_amount"]
            if job["salary_not_disclosed"] == true
              j.salary_not_disclosed = true
            else
              j.salary_not_disclosed = false
            end
            j.summary = job["summary"]
            j.job_location_id = jl.id unless job_location.empty?
            j.remote_work = s.find('remote-work').first.content

            unless country.nil?
              if country.subregion == "Northern America"
                j.xml_import_pairing_logic = true
              end
            else
              if j.remote_work == true
                j.xml_import_pairing_logic = true
              end
            end

            if j.active
              j.xml_import_pairing_logic = true
            end

            if (job_location.empty? and j.remote_work == false) or j.minimum_compensation_amount.blank? or j.summary.empty?
              if (job_location.empty? and j.remote_work == false)
                j.job_location_id = nil
              end
              j.basic_complete = false
              j.overview_complete = false
              j.detail_preview = false
              j.profile_complete = false
              j.active = false
              j.xml_import_pairing_logic = false

              posting_record = Posting.find_by_sql("SELECT `postings`.* FROM `postings` WHERE (job_id = #{j.id} and employer_id = #{j.employer.id}) LIMIT 1").first
              unless posting_record.nil?
                posting_record.hilo_share = false
                posting_record.facebook_share = false
                posting_record.twitter_share = false
                posting_record.linkedin_share = false
                posting_record.url_share = false
                posting_record.save
              end
            end
            if j.active
              @jobs_active_count[j.hiring_company_name] = @jobs_active_count[j.hiring_company_name].to_i + 1 if repeat_flag == false
            else
              if j.xml_import_pairing_logic
                @jobs_active_count[j.hiring_company_name] = @jobs_active_count[j.hiring_company_name].to_i + 1 if repeat_flag == false
              else
                @jobs_inactive_count[j.hiring_company_name] = @jobs_inactive_count[j.hiring_company_name].to_i + 1 if repeat_flag == false
              end
            end
          end
          j.vendor_name = vendor_name
          begin
            j.save(:validate=>false)
          rescue
            @jobs_failed_count[j.hiring_company_name] = @jobs_failed_count[j.hiring_company_name].to_i + 1 if repeat_flag == false
            next
          end

          if proceed
            begin

              #profile-responsibilities
              profile_respo_hash = Time.now
              s.find('profile-responsibilities/profile-responsibility').each do |d|
                profile_responsibilities<<d.find('name').first.content
              end
              profile_responsibility_flag = j.add_responsibilities(profile_responsibilities[0, 5])
              puts "Time taken in creating profile respo hash is : #{Time.now - profile_respo_hash}"


              #desired-employments
              desired_emp_hash = Time.now
              s.find('desired-employments/desired-employment').each do |d|
                desired_employment = ''
                p d.find('name').first.content.downcase
                desired_employment = d.find('name').first.content.downcase unless d.find('name').first.content.empty?
                if desired_employment == 'seasonal'
                  desired_employment = "part time"
                elsif desired_employment == 'temporary'
                  desired_employment = "temp"
                elsif desired_employment == 'permanent'
                  desired_employment = "full time"
                end
                p desired_employment
                de = []
                de = DesiredEmployment.find_by_sql("SELECT `desired_employments`.* FROM `desired_employments` WHERE (LCASE(name) like '%#{desired_employment}%')") unless desired_employment.empty?
                unless de.empty?
                  job_criteria_desired_employments["desired_employment_id"] = de.first.id
                  job_criteria_desired_employments["job_id"] = j.id 
                end
              end
              JobCriteriaDesiredEmployment.destroy_all(:job_id=>j.id)
              p "*******************************DESIRED EMPLOYMENT*******************************"
              p job_criteria_desired_employments
              JobCriteriaDesiredEmployment.create(job_criteria_desired_employments) unless job_criteria_desired_employments.empty?
              puts "Time taken in creating desired emp hash is: #{Time.now - desired_emp_hash} "

              #new_certificates

              cert_hash = Time.now
              flag = "1"
              s.find('new-certificates/new-certificate').each do |d|
                new_certificates[flag] = Hash.new
                %w[certification-description certification-name certifying-organization occupation source-url sub-occupation].each do |c|
                  new_certificates[flag].merge!({c.gsub(/-/, "_") => d.find(c).first.content}) unless d.find(c).first.content.empty?
                end
                flag = (flag.to_i + 1).to_s
              end
              new_certificates.each do |key, value|
                value.each do |k, v|
                  if k == "certification_name"
                    c = NewCertificate.find_by_sql("SELECT `new_certificates`.* FROM `new_certificates` WHERE (LCASE(certification_name) like '%#{new_certificates[key][k].downcase}%')")
                    if c.empty?
                      c = NewCertificate.create(new_certificates[key].merge!({"activated"=>false}))
                      job_criteria_certificates[key] = {"job_id"=>j.id, "new_certificate_id"=>c.id, "order_id"=>key.to_i, "required_flag"=>true}
                    else
                      job_criteria_certificates[key] = {"job_id"=>j.id, "new_certificate_id"=>c.first.id, "order_id"=>key.to_i, "required_flag"=>true}
                    end
                  end
                end
              end

              #licenses

              s.find('licenses/license').each do |d|
                licenses[flag] = Hash.new
                %w[license-description license-name licensing-agency occupation source-url].each do |c|
                  licenses[flag].merge!({c.gsub(/-/, "_") => d.find(c).first.content}) unless d.find(c).first.content.empty?
                end
                flag = (flag.to_i + 1).to_s
              end
              licenses.each do |key, value|
                value.each do |k, v|
                  if k == "license_name"
                    c = License.find_by_sql("SELECT `licenses`.* FROM `licenses` WHERE (LCASE(license_name) like '%#{licenses[key][k].downcase}%')")
                    if c.empty?
                      c = License.create(licenses[key].merge!({"activated"=>false}))
                      job_criteria_certificates[key] = {"job_id"=>j.id, "license_id"=>c.id, "order_id"=>key.to_i, "required_flag"=>true}
                    else
                      job_criteria_certificates[key] = {"job_id"=>j.id, "license_id"=>c.first.id, "order_id"=>key.to_i, "required_flag"=>true}
                    end
                  end
                end
              end

              JobCriteriaCertificate.destroy_all(:job_id=>j.id)
              job_criteria_certificates.each do |key, value|
                JobCriteriaCertificate.create(job_criteria_certificates[key])
              end
              puts "Time taken in creating cert & license hash is : #{Time.now - cert_hash}"

              #languages

              lang_hash = Time.now
              flag = "1"
              s.find('languages/language').each do |d|
                unless d.find('name').first.content.empty?
                  l = Language.find_by_sql("SELECT `languages`.* FROM `languages` WHERE (LCASE(name) like '%#{d.find('name').first.content.downcase}%')")
                  unless l.empty?
                    job_criteria_languages[flag] = {"job_id"=>j.id, "language_id" => l.first.id, "proficiency_val"=>"a", "required_flag"=>true}
                  else
                    l = Language.find_by_id(5)
                    job_criteria_languages[flag] = {"job_id"=>j.id, "language_id" => l.id, "proficiency_val"=>"a", "required_flag"=>true}
                  end
                else
                  l = Language.find_by_id(5)
                  job_criteria_languages[flag] = {"job_id"=>j.id, "language_id" => l.id, "proficiency_val"=>"a", "required_flag"=>true}
                end
                flag = (flag.to_i + 1).to_s
              end
              JobCriteriaLanguage.destroy_all(:job_id=>j.id)
              job_criteria_languages.each do |key, value|
                JobCriteriaLanguage.create(job_criteria_languages[key])
              end
              puts "Time taken in creating lang hash is: #{Time.now - lang_hash}"

              #universities
              univ_hash = Time.now
              flag = "1"
              s.find('universities/university').each do |d|
                unless d.find('institution').first.content.empty?
                  l = University.find_by_sql("SELECT `universities`.* FROM `universities` WHERE (LCASE(institution) like '%#{d.find('institution').first.content.downcase}%')")
                  unless l.empty?
                    added_universities[flag] = {"adder_id"=>j.id, "adder_type"=>"JobPosition", "university_id" => l.first.id}
                  end
                end
                flag = (flag.to_i + 1).to_s
              end
              AddedUniversity.destroy_all(:adder_id=>j.id, :adder_type=>"JobPosition")
              added_universities.each do |key, value|
                AddedUniversity.create(added_universities[key])
              end
              puts "Time taken in creating univ hash is: #{Time.now - univ_hash}"

              #degrees
              deg_hash = Time.now
              unless s.find('degrees').first.find('degree').first.nil?
                degree_name = s.find('degrees').first.find('degree').first.find('name').first.content
                unless degree_name.nil?
                  l = Degree.find_by_sql("SELECT `degrees`.* FROM `degrees` WHERE (LCASE(name) like '%#{degree_name.downcase}%')")
                  unless l.empty?
                    added_degrees = {"adder_id"=>j.id, "adder_type"=>"JobPosition", "degree_id" => l.first.id, "required_flag"=>true}
                  end
                end
              end
              AddedDegree.destroy_all(:adder_id=>j.id, :adder_type=>"JobPosition")
              added_degrees.each do |key, value|
                AddedDegree.create(added_degrees[key])
              end
              puts "Time taken in creating degree hash is: #{Time.now - deg_hash}"

              # Adding role by XML Provided data
              occupation_data_hash = Time.now
              flag = "1"

              # Adding role by job name
              if flag.to_i <= 3
                count = 3
                search = OccupationData.search do
                  query = j.name
                  query = strip_tags(query.gsub(/['\"]|AND|OR/, '').squeeze(" ").strip)
                  query = query.split('-')[0]

                  fulltext query do
                    minimum_match 1
                  end
                  with :banned, false
                  order_by(:score, :desc)
                  paginate :page => 1, :per_page => count
                end
                search.results.each do |result|
                  desired_role = result.onetsoc_code
                  unless desired_role.nil?
                    add_this_role = true
                    added_roles.each do |key, value|
                      if added_roles[key]["code"] == desired_role
                        add_this_role = false
                      end
                    end
                    added_roles[flag] = {"adder_id"=>j.id, "adder_type" => "JobPosition", "code" => desired_role} if add_this_role
                    flag = (flag.to_i + 1).to_s
                  end
                end
              end
              AddedRole.destroy_all(:adder_id=>j.id, :adder_type=>"JobPosition")
              added_roles.each do |key, value|
                AddedRole.create(added_roles[key])
              end
              puts "Time taken in creating occupation data hash is #{Time.now - occupation_data_hash}"

            rescue
              @jobs_failed_count[j.hiring_company_name] = @jobs_failed_count[j.hiring_company_name].to_i + 1 if repeat_flag == false
              next
            end

            if (job_location.empty? and j.remote_work == false) or !profile_responsibility_flag or job_criteria_desired_employments.empty? or j.summary.empty? or j.minimum_compensation_amount.blank? or j.maximum_compensation_amount.blank?
              j.basic_complete = false
            else
              j.basic_complete = true
            end

            j.personality_work_complete = true
            j.personality_role_complete = true

            if added_roles.empty?
              j.credential_complete = false
            else
              j.credential_complete = true
            end

            if j.credential_complete and j.basic_complete
              j.profile_complete = true
              j.overview_complete = true
              j.personality_work_complete = true
              j.personality_role_complete = true
              j.detail_preview = true
            else
              j.profile_complete = false
              j.active = false
              j.overview_complete = false
              j.detail_preview = false
            end

            j.save(:validate=>false)

            if j.credential_complete == true and j.profile_complete == true and j.basic_complete == true and j.overview_complete == true and j.detail_preview == true and j.personality_work_complete == true and j.personality_role_complete == true
              unless country.nil?
                if country.subregion == "Northern America"
                  j.xml_import_pairing_logic = true
                end
              else
                if j.remote_work == true
                  j.xml_import_pairing_logic = true
                end
              end

              if j.xml_import_pairing_logic
                @jobs_active_count[j.hiring_company_name] = @jobs_active_count[j.hiring_company_name].to_i + 1 if repeat_flag == false
              else
                @jobs_inactive_count[j.hiring_company_name] = @jobs_inactive_count[j.hiring_company_name].to_i + 1 if repeat_flag == false
              end

              j.save(:validate=>false)

              p "***********************************************************"
              p "#{j.hiring_company_name} - #{@job_count+1}"
              p "Active Count"
              p @jobs_active_count
              p "Inactive Count"
              p @jobs_inactive_count
              p "***********************************************************"

            else
              @jobs_inactive_count[j.hiring_company_name] = @jobs_inactive_count[j.hiring_company_name].to_i + 1 if repeat_flag == false

              p "***********************************************************"
              p "#{j.hiring_company_name} - #{@job_count+1}"
              p "Active Count"
              p @jobs_active_count
              p "Inactive Count"
              p @jobs_inactive_count
              p "***********************************************************"
            end
          end

          end_time = Time.now - start_time
          @job_count = @job_count + 1 if repeat_flag == false
          puts "time taken for #{@job_count} job is #{end_time}"
        }

        p "********************************BENCHMARK**************************************"
        p benchmark
        p "********************************BENCHMARK**************************************"
      end

      Job.where(:vendor_name=>vendor_name, :hiring_company_name=>@hiring_company_name).each do |j|
        if !@jobs_in_xml.include?(j.vendor_job_id)
          puts "Deleteing Job #{j.id}"
          @jobs_deleted_count[j.hiring_company_name] = @jobs_deleted_count[j.hiring_company_name].to_i + 1
          j.destroy
        end
      end
      
    end

    copy_xml()
  end
end
