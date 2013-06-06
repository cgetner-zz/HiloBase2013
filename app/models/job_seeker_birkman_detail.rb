# coding: UTF-8

class JobSeekerBirkmanDetail < ActiveRecord::Base
    belongs_to :job_seeker
    attr_accessible :job_seeker_id
    
    def before_create
        if self.responded_birkman_set_number.nil?
          self.responded_birkman_set_number = 0
        end
    end
    
    def score_fetched?
        if !self.grid_work_environment_x.blank?  and !self.grid_work_environment_y.blank? and !self.grid_work_role_x.blank? and !self.grid_work_role_y.blank?
            return true
        else
            return false
        end
    end

    # This task is for individual job seeker once their payment is done
    ##RSPEC: Can't be tested
    def self.job_seeker_submit_birkman_test(js)
        jd = where("job_seeker_id = ? AND test_complete = ? AND test_submitted = ?", js.to_i, true, false).first

        if not jd.nil?
          if jd.pass_through == true
            @xml_post = form_passthrough_response_xml(jd)
            url = URI.parse('https://api.birkman.com/xml-3.0-append.php')
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            response = http.post(url.path, @xml_post,"content-type"=>"text/xml")
            self.parse_test_submit_xml(response.body,jd)
          else
            @xml_post = form_post_answer_xml(jd)
            url = URI.parse('https://api.birkman.com/xml-3.0-append.php')
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            response = http.post(url.path, @xml_post,"content-type"=>"text/xml")
            self.parse_test_submit_xml(response.body,jd)
          end
          return @xml_post,response
        end
        #jd = JobSeekerBirkmanDetail.find_by_job_seeker_id(job_seeker.to_i, :conditions => ["test_complete = ? AND test_submitted = ? AND job_seekers.activated = ?", true, false, true], :select => "job_seeker_birkman_details.*", :joins=>"join job_seekers on job_seeker_birkman_details.job_seeker_id = #{job_seeker.to_i}")
        #js_details = JobSeekerBirkmanDetail.find(:all,:select=>"job_seeker_birkman_details.*",:joins=>"join job_seekers on job_seeker_birkman_details.job_seeker_id = job_seekers.id",:conditions=>["test_complete = ? AND test_submitted = ? AND job_seekers.activated = ?", true, false, true],:limit=>5)
    end
    ##RSPEC: Can't be tested
    def self.job_seeker_download_pdf(job_seeker)
        flag,xml_post,response = ""
        rows = where("test_complete = ? and test_submitted = ? and pdf_saved = ? and job_seeker_id = ?",true,true,false,job_seeker.to_i).first
        flag,xml_post,response = self.download_pdf(rows)
        return flag,xml_post,response
    end
    # Task for individual job seeker ends here
    ##RSPEC: Can't be tested
    def self.cron_submit_birkman_test
        js_details = JobSeekerBirkmanDetail.select("job_seeker_birkman_details.*").joins("join job_seekers on job_seeker_birkman_details.job_seeker_id = job_seekers.id").where("test_complete = ? AND test_submitted = ? AND job_seekers.activated = ? AND job_seekers.request_deleted = ? AND job_seekers.deleted_at IS NULL", true, false, true, false).limit(5).all
        
        for jd in js_details
              if jd.pass_through
                  @xml_post = form_passthrough_response_xml(jd)
                  url = URI.parse('https://api.birkman.com/xml-3.0-append.php')
                  http = Net::HTTP.new(url.host, url.port)
                  http.use_ssl = true
                  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                  response = http.post(url.path, @xml_post,"content-type"=>"text/xml")
                  self.parse_test_submit_xml(response.body,jd)  
              else
                  @xml_post = form_post_answer_xml(jd)
                  url = URI.parse('https://api.birkman.com/xml-3.0-append.php')
                  http = Net::HTTP.new(url.host, url.port)
                  http.use_ssl = true
                  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                  response = http.post(url.path, @xml_post,"content-type"=>"text/xml")
                  self.parse_test_submit_xml(response.body,jd)
              end
        end
        return @xml_post,response
    end
    
    ##RSPEC: Can't be tested
    def self.parse_test_submit_xml(xml_data,jd)
        resp_hash = {:error=>""}
        begin
                xml_doc = REXML::Document.new(xml_data)
                xml_doc.elements.each("//ErrorProcessMessage"){|element|
                       resp_hash[:error] = element.elements['Description'].text
                }

                if resp_hash[:error].blank?
                    jd.test_submitted = true
                    jd.save(:validate => false)
                end  
          rescue => e
                raise e
          end
          return resp_hash
   end
  
  ##RSPEC: Can't be tested
  def self.form_passthrough_response_xml(jd)
      job_seeker = JobSeeker.where("id=?", jd.job_seeker_id).first
      time_obj = Time.now
      creation_date_time = time_obj.strftime("%Y-%m-%d") + "T" + time_obj.strftime("%H:%M:%S") + "-06:00"
      api_key = BIRKMAN_API_KEY
      unique_key = jd.unique_identifier
      first_name = jd.pass_first_name
      last_name = jd.pass_last_name
      
      #~ first_name = 'Yum'
      #~ last_name = 'Gum'
      #~ email = 'dsteckbeck@birkman.com'
      #~ unique_key = "c7ed9a02983fff5d78913d6c8d1d46b0"
      
      
      test_weq_xml = "" 
      jwq_resp = JobSeekerWorkenvQuestion.where("job_seeker_id = ?", jd.job_seeker_id).all
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
  
  ##RSPEC: Can't be tested
  def self.form_post_answer_xml(jd)
        job_seeker = JobSeeker.where("id=?", jd.job_seeker_id).first
        time_obj = Time.now
        creation_date_time = time_obj.strftime("%Y-%m-%d") + "T" + time_obj.strftime("%H:%M:%S") + "-06:00"
        api_key = BIRKMAN_API_KEY
        test_one_xml = ""
        test_two_xml = ""
        test_three_xml = ""
        test_weq_xml = ""
        
        birkman_question_responses = BirkmanQuestionResponse.where("job_seeker_id = ? ", jd.job_seeker_id).order("id asc").all
        
        1.upto(125){|i|
          if not birkman_question_responses[i - 1].blank?
            test_one_xml << "<Item section='self' sequence='#{i}'><Response type='boolean' sequence=''>" + (birkman_question_responses[i - 1].response ? "T" : "F") + "</Response></Item>"
          end
        }
        
        126.upto(250){|i|
          if not birkman_question_responses[i - 1].blank?
            test_two_xml << "<Item section='most' sequence='#{(i - 125)}'><Response type='boolean' sequence=''>" + (birkman_question_responses[i - 1].response ? "T" : "F") + "</Response></Item>"
          end
        }
        
        bji = BirkmanJobInterest.order("id ASC").all
        b_hash = {}
        bji.each{|b|
           b_hash.update({b.set_number.to_s => []}) if not b_hash.has_key?(b.set_number.to_s)
           b_hash[b.set_number.to_s] << b.id
        }

        bji_resp = BirkmanJobInterestResponse.where("job_seeker_id = ? ",jd.job_seeker_id).order("id ASC").all
        
        
        key_num = 1
        tag_val = ""
        bji_resp.each_with_index{|a,cnt|
            q, r = (cnt + 1).divmod(2)
            
            alphabet = alphabet_by_num(b_hash[key_num.to_s].index(a.birkman_job_interest_id))
            seq = a.choice == "first" ? "1" : "2"
            tag_val << "<Response type='multichoice' sequence='#{seq}'>#{alphabet}</Response>"
            
            if r == 0
                test_three_xml << "<Item section='interests' sequence='#{key_num}'>" + tag_val + "</Item>"
                tag_val = ""
                key_num =  key_num + 1 
            end
        }
         
        jwq_resp = JobSeekerWorkenvQuestion.where("job_seeker_id = ?", jd.job_seeker_id).all
        jwq_resp.each_with_index{|ans,cnt|
            test_weq_xml << "<Item section='bweq' sequence='#{(cnt + 1)}'><Response type='multichoice' sequence=''>#{ans.score}</Response></Item>"

        }
        
        xml = "<?xml version='1.0' encoding='UTF-8'?><ProcessCandidate systemEnvironmentCode='#{$BIRKMAN_MODE}' releaseID='3.0' versionID='1.2' languageCode='en-US' xmlns='http://www.hr-xml.org/3' xmlns:oa='http://www.openapplications.org/oagis/9'> 
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
                       <oa:ActionCriteria/>
                  </oa:Process>
                  <Candidate>
                        <DocumentID schemeID='UserID'>#{jd.unique_identifier}</DocumentID>
                        <CandidatePerson>
                            <PersonName>
                                <oa:GivenName>#{job_seeker.first_name}</oa:GivenName>
                                <MiddleName></MiddleName>
                                <FamilyName>#{job_seeker.last_name}</FamilyName>
                             </PersonName>
                        </CandidatePerson>
                        <UserArea>
                            <AssessmentItems>
                                #{test_one_xml}
                                #{test_two_xml}
                                #{test_three_xml}
                                #{test_weq_xml}
                            </AssessmentItems>
                        </UserArea>
              </Candidate>
         </DataArea>
      </ProcessCandidate>"

      return xml
    end

    def self.alphabet_by_num(num)
        case num
            when 0
              return "A"
            when 1
              return "B"
            when 2
              return "C"
            when 3
              return "D"
            else
              return "A"  
        end
    end
    ##RSPEC: Can't be tested
    def self.cron_download_pdf
      flag,xml_post,response = ""
        rows = where("test_complete = ? and test_submitted = ? and pdf_saved = ?",true,true,false).limit(5).all
        for item in rows
             flag,xml_post,response  = self.download_pdf(item)
        end
        return flag,xml_post,response   
    end
    ##RSPEC: Can't be tested
    def self.download_pdf(job_seeker_birkman_detail)
       @xml_post = self.xml_for_pdf_report(job_seeker_birkman_detail)
       
       url = URI.parse('https://api.birkman.com/xml-3.0-report.php')
       http = Net::HTTP.new(url.host, url.port)
       http.use_ssl = true
       http.verify_mode = OpenSSL::SSL::VERIFY_NONE
       response = http.post(url.path, @xml_post,"content-type"=>"text/xml")
       
       pdf_hash = self.parse_pdf_report_xml(response.body)
       
       if pdf_hash[:error].blank? and ["OrderComplete","ScoredTestPendingReview"].include?(pdf_hash[:status_code])
          self.create_pdf_file(pdf_hash,job_seeker_birkman_detail)
          self.save_work_role_score(pdf_hash,job_seeker_birkman_detail)
          job_seeker_birkman_detail.pdf_saved = true
          job_seeker_birkman_detail.save(:validate => false)
          @notification = JobSeekerNotification.new
          @notification.job_seeker_id = job_seeker_birkman_detail.job_seeker_id
          @notification.notification_type_id = 2
          @notification.notification_message_id = 2
          @notification.visibility = true
          @notification.save
          return true,@xml_post,response
        else
            return false,@xml_post,response
        end
    end
    ##RSPEC: Can't be tested
    def self.save_work_role_score(pdf_hash,job_seeker_birkman_detail)
        for item in pdf_hash[:score]
            item.each{|k,v|
                case k
                  when "grid_work_environment_x"
                      job_seeker_birkman_detail.grid_work_environment_x = v
                  when "grid_work_environment_y"
                      job_seeker_birkman_detail.grid_work_environment_y = v
                  when "grid_work_role_x"
                      job_seeker_birkman_detail.grid_work_role_x = v
                  when "grid_work_role_y"
                      job_seeker_birkman_detail.grid_work_role_y = v
                end
            }
        end
        job_seeker_birkman_detail.save(:validate => false)
    end
    ##RSPEC: Can't be tested
    def self.create_pdf_file(pdf_hash,job_seeker_birkman_detail)
      file_name = "#{Rails.root}/#{BIRKMAN_PDF_PATH}/#{job_seeker_birkman_detail.job_seeker_id}_birkman_report.pdf"
      # start -- check if the directories exist else create those
      if not File.exists?("#{Rails.root}/public/system/")
            Dir.mkdir("#{Rails.root}/public/system/")
      end

      if not File.exists?("#{Rails.root}/public/system/birkman_report")
          Dir.mkdir("#{Rails.root}/public/system/birkman_report")
      end
      # end -- check if the directories exist else create those
      pdf_text = Base64.decode64(pdf_hash[:EmbeddedData])
      f = File.open(file_name, 'wb') {|f| f.write(pdf_text)}

    end
    ##RSPEC: Can't be tested
    def self.parse_pdf_report_xml(xml_data)
        pdf_hash = {:error=>"",:status_code=>"",:FileName=>"",:EmbeddedData=>"",:score=>[]}
        begin
                xml_doc = REXML::Document.new(xml_data)
                xml_doc.elements.each("//ErrorProcessMessage"){|element|
                       pdf_hash[:error] = element.elements['Description'].text
                }
                
                if  pdf_hash[:error].blank?
                    xml_doc = REXML::Document.new(xml_data)
              
                    xml_doc.elements.each("//AssessmentStatus") { |element| 
                          pdf_hash[:status_code] = element.elements['AssessmentStatusCode'].text
                    }
                    
                    if ["OrderComplete","ScoredTestPendingReview"].include?(pdf_hash[:status_code])
                        xml_doc.elements.each("//Attachment") { |element| 
                            pdf_hash[:EmbeddedData] = element.elements['oa:EmbeddedData'].text
                            pdf_hash[:FileName] = element.elements['oa:FileName'].text
                        }
                        
                         xml_doc.elements.each("//Score"){|element|
                            pdf_hash[:score].push({element.elements['ScoreText'].text => element.elements['ScoreNumeric'].text})
                        }
                    end
                end  
          rescue => e
                #raise e
          end
          return pdf_hash
    end
    ##RSPEC: Can't be tested
    def self.xml_for_pdf_report(job_seeker_birkman_detail)
          time_obj = Time.now
          creation_date_time = time_obj.strftime("%Y-%m-%d") + "T" + time_obj.strftime("%H:%M:%S") + "-06:00"
          api_key = BIRKMAN_API_KEY
          #PDFFormatID -> 2400284 - this gives career forward guide
          #PDFFormatID -> 2400111 - this give interest report
           @xml_post= "<GetAssessmentReport systemEnvironmentCode='#{$BIRKMAN_MODE}' releaseID='3.0' languageCode='en-US' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns='http://www.hr-xml.org/3' xmlns:oa='http://www.openapplications.org/oagis/9'>

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
             <DocumentID>#{job_seeker_birkman_detail.unique_identifier}</DocumentID>
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

end