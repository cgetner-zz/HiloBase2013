# coding: UTF-8

require 'net/https'
require 'uri'
class QuestionnaireController < ApplicationController
   layout :determine_layout
   before_filter :required_loggedin_job_seeker
   before_filter :validate_current_step,:only => [:index, :continue_to_pairing_profile]
   protect_from_forgery :except => [:return_from_birkman]

   def index
     #@job_seeker = JobSeeker.find(session[:job_seeker].id)
      form_birkman_detail_objects()
      if session[:pass_through].nil? and @job_seeker_birkman_detail.unique_identifier.blank?
         session[:pass_through] = true
         save_citizenship()
         form_birkman_detail_objects()
         @job_seeker_birkman_detail.responded_birkman_set_number = BIRKMAN_STEP_CITIZENSHIP
         @job_seeker_birkman_detail.save(:validate => false)
     #--Pass through Ipad--
      elsif session[:pass_through]!=true and session[:pass_through]!=false and !session[:pass_through].blank?
         save_citizenship()
         form_birkman_detail_objects()
         @job_seeker_birkman_detail.responded_birkman_set_number = BIRKMAN_STEP_CITIZENSHIP
         @job_seeker_birkman_detail.save(:validate => false)
         pass_through_verify_birkman_id()
      end
     #--/Pass through Ipad--
      form_birkman_detail_objects()
      determine_question_set()
   end

   def continue_to_payment
      job_seeker = JobSeeker.update(session[:job_seeker].id, :completed_registration_step => QUESTIONNAIRE_STEP)
      reload_seeker_session(job_seeker)
      redirect_to :controller=>:payment
      return
   end
   
   def save_old_id
      @job_seeker = JobSeeker.find(session[:job_seeker].id)
      @job_seeker.save_previous_id(params[:prev_birkman_id])
      redirect_to :controller => :questionnaire, :action => :continue_to_payment
      return
   end

   def save_citizenship
      form_birkman_detail_objects()
      if @job_seeker_birkman_detail.responded_birkman_set_number.nil? or @job_seeker_birkman_detail.responded_birkman_set_number < BIRKMAN_STEP_CITIZENSHIP
        @job_seeker_birkman_detail.us_citizen = true
        @job_seeker_birkman_detail.responded_birkman_set_number = BIRKMAN_STEP_CITIZENSHIP
        @job_seeker_birkman_detail.save(:validate => false)
        if @job_seeker_birkman_detail.unique_identifier.blank?
            generate_birkman_key()
        end
      end
   end

  def save_work_env_questions
      
      if !session[:pass_through].blank? and session[:pass_through]!=false
         session[:pass_through]=false
      end
      form_birkman_detail_objects()
      if @job_seeker_birkman_detail.responded_birkman_set_number < BIRKMAN_STEP_WORKENV
          
          JobSeekerWorkenvQuestion.save_workenv_for_jobseeker(params[:work_env_values],session[:job_seeker].id,params[:save_type])
          form_birkman_detail_objects()
          
          if @job_seeker_birkman_detail.test_complete == true
           @job_seeker.completed_registration_step = QUESTIONNAIRE_STEP
           @job_seeker.save
           reload_seeker_session(@job_seeker)
          end
      end  
      
      if params[:save_type] == "return_later"
        redirect_to :controller => "login",:action => "logout"
      else
        redirect_to :controller => "questionnaire",:action => "index"
      end
      
      return
  end
  
  def save_test_one_questions
      form_birkman_detail_objects()

      BirkmanQuestionResponse.save_test_one_response(params[:test_response],session[:job_seeker].id,params[:save_type])
      if params[:save_type] == "return_later"
        redirect_to :controller => "login",:action => "logout"
      else
        redirect_to :controller => "questionnaire",:action => "index"
      end
  end
  
  def save_test_two_questions
      form_birkman_detail_objects()
      BirkmanQuestionResponse.save_test_two_response(params[:test_response],session[:job_seeker].id,params[:save_type])
      if params[:save_type] == "return_later"
        redirect_to :controller => "login",:action => "logout"
      else
        redirect_to :controller => "questionnaire",:action => "index"
      end
  end

  def save_test_three_questions
      form_birkman_detail_objects()

      res_arr = params[:test_response].split("__")
      first_choice = res_arr[0].to_i
      second_choice = res_arr[1].to_i
      
      if first_choice == 3
        first_choice = 2
      elsif first_choice == 5
        first_choice = 3
      elsif first_choice == 7  
        first_choice = 4
      end

      if second_choice == 2
          second_choice = 1
      elsif second_choice == 4
          second_choice = 2
      elsif second_choice == 6
          second_choice = 3
      elsif second_choice == 8  
          second_choice = 4
      end

      @birkman_test_complete = BirkmanJobInterestResponse.save_test_three_response(@job_seeker_birkman_detail,session[:job_seeker].id,first_choice,second_choice,params[:save_type])

      reload_seeker_session() if @birkman_test_complete

      if params[:save_type] == "return_later"
        redirect_to :controller => "login",:action => "logout"
      elsif @birkman_test_complete
        redirect_to :controller => "pairing_profile",:action => "credentials"
      else
        redirect_to :controller => "questionnaire",:action => "index"
      end
  end

  def verify_birkman_id
        if(!params[:birkman_id].nil? and !params[:first_name].nil? and !params[:last_name].nil? and !params[:email].nil?)
            @xml_post = verify_xml(params[:birkman_id], params[:first_name], params[:last_name], params[:email])
        #else
            #@xml_post = verify_xml(session[:pass_through], @job_seeker.first_name, @job_seeker.last_name, @job_seeker.email)
        end    
        url = URI.parse('https://api.birkman.com/xml-3.0-transfer.php')
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.post(url.path, @xml_post,'content-type'=>'text/xml')

        @verify_hash = parse_verify_xml(response.body)

        if @verify_hash[:error].blank?
            session[:pass_through] = false
            form_birkman_detail_objects()
            @job_seeker_birkman_detail.unique_identifier = @verify_hash[:document_id]
            @job_seeker_birkman_detail.birkman_user_id = @verify_hash[:document_id]
            @job_seeker_birkman_detail.pass_through = true
            @job_seeker_birkman_detail.pass_first_name = params[:first_name]
            @job_seeker_birkman_detail.pass_last_name = params[:last_name]
            @job_seeker_birkman_detail.pass_email = params[:email]
            @job_seeker_birkman_detail.pass_birkman_code = params[:birkman_id]
            @job_seeker_birkman_detail.save(:validate => false)
            session[:show_birkman_verified_msg] = true
        end
  end
        
  def pass_through_verify_birkman_id
      @xml_post = verify_xml(session[:pass_through], @job_seeker.first_name, @job_seeker.last_name, @job_seeker.email)
      url = URI.parse('https://api.birkman.com/xml-3.0-transfer.php')
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.post(url.path, @xml_post,'content-type'=>'text/xml')

      @verify_hash = parse_verify_xml(response.body)

      if @verify_hash[:error].blank?
         form_birkman_detail_objects()
         @job_seeker_birkman_detail.unique_identifier = @verify_hash[:document_id]
         @job_seeker_birkman_detail.birkman_user_id = @verify_hash[:document_id]
         @job_seeker_birkman_detail.pass_through = true
         @job_seeker_birkman_detail.pass_first_name = @job_seeker.first_name
         @job_seeker_birkman_detail.pass_last_name = @job_seeker.last_name
         @job_seeker_birkman_detail.pass_email = @job_seeker.email
         @job_seeker_birkman_detail.pass_birkman_code = session[:pass_through]
         @job_seeker_birkman_detail.save(:validate => false)
         session[:show_birkman_verified_msg] = true
         session[:pass_through] = false
      else
         session[:wrong_birkman_id] = true
      end
  end

  def clear_pass_through
    session[:pass_through] = false
    render :text => "done"
  end

private

    def form_birkman_detail_objects
          @job_seeker = JobSeeker.find(session[:job_seeker].id)
          @job_seeker_birkman_detail =@job_seeker.job_seeker_birkman_detail
      
          if @job_seeker_birkman_detail.nil?
            @job_seeker_birkman_detail  = JobSeekerBirkmanDetail.new({:job_seeker_id => session[:job_seeker].id})
          end
    end

    def determine_question_set
        @job_seeker_birkman_detail =@job_seeker.job_seeker_birkman_detail

        if !@job_seeker_birkman_detail.nil? and @job_seeker_birkman_detail.test_complete == true
          redirect_to :controller => :pairing_profile, :action => :credentials
          return false
        end

        if @job_seeker_birkman_detail.nil? or @job_seeker_birkman_detail.responded_birkman_set_number == 0
            @test_step = 0
        elsif @job_seeker_birkman_detail.responded_birkman_set_number == BIRKMAN_STEP_CITIZENSHIP
            @test_step = BIRKMAN_STEP_CITIZENSHIP
            questions_for_work_env()
        elsif @job_seeker_birkman_detail.responded_birkman_set_number == BIRKMAN_STEP_WORKENV
            @test_step = BIRKMAN_STEP_WORKENV
            questions_for_testone()
        elsif @job_seeker_birkman_detail.responded_birkman_set_number == BIRKMAN_STEP_TEST_ONE
            @test_step = BIRKMAN_STEP_TEST_ONE
            questions_for_testtwo()      
        elsif @job_seeker_birkman_detail.responded_birkman_set_number == BIRKMAN_STEP_TEST_TWO
            @test_step = BIRKMAN_STEP_TEST_TWO
            questions_for_testthree()
        elsif @job_seeker_birkman_detail.responded_birkman_set_number == BIRKMAN_STEP_TEST_THREE
            @test_step = BIRKMAN_STEP_TEST_THREE
        else
            @test_step = 0
        end
    end

    def questions_for_work_env
      @work_questions = WorkenvQuestion.seeker_next_questions_for_work_env(@job_seeker_birkman_detail)
      @work_questions_resp = Hash.new
      @work_questions.each_with_index{|obj , i|
         jswq = JobSeekerWorkenvQuestion.find(:first,:conditions=>["job_seeker_id = ? and workenv_question_id = ?",session[:job_seeker].id,obj.id])
         if jswq.nil?
            @work_questions_resp["#{obj.id}"] = nil
         else
            @work_questions_resp["#{obj.id}"] = jswq.score
         end
      }
    end

    def questions_for_testone
         @birkman_questions = BirkmanQuestionResponse.seeker_next_questions_for_set_one(@job_seeker_birkman_detail)
         @birkman_questions_resp = Hash.new
         
         @birkman_questions.each_with_index{|obj,i|
              object = BirkmanQuestionResponse.find(:first,:conditions=>["job_seeker_id = ? and birkman_question_id = ?",session[:job_seeker].id,obj.id])
              if object.nil?
                @birkman_questions_resp["#{obj.id}"] = nil
              else
                @birkman_questions_resp["#{obj.id}"] = object.response
              end
            }
    end

    def questions_for_testtwo
          @birkman_questions = BirkmanQuestionResponse.seeker_next_questions_for_set_two(@job_seeker_birkman_detail)
          @birkman_questions_resp = Hash.new
          
          @birkman_questions.each_with_index{|obj,i|
              object = BirkmanQuestionResponse.find(:first,:conditions=>["job_seeker_id = ? and birkman_question_id = ?",session[:job_seeker].id,obj.id])
              if object.nil?
                @birkman_questions_resp["#{obj.id}"] = nil
              else
                @birkman_questions_resp["#{obj.id}"] = object.response
              end
            }
    end

    def questions_for_testthree
          @birkman_questions = BirkmanJobInterestResponse.seeker_next_questions_for_set_three(@job_seeker_birkman_detail)
          @birkman_questions_resp = Hash.new
          
          @birkman_questions.each_with_index{|obj,i|
            object = BirkmanJobInterestResponse.find(:first,:conditions=>["birkman_job_interest_id = ? and job_seeker_id = ?",obj.id,session[:job_seeker].id])
            if object.nil?
               @birkman_questions_resp["#{obj.id}"] = nil
            else
               @birkman_questions_resp["#{obj.id}"] = object.choice
            end
          }  
    end

    def validate_current_step
      redirect_to(redirect_to_registration_step()) if (session[:job_seeker].completed_registration_step.to_i != ACCOUNT_SETUP_STEP)
    end

    def determine_layout
          case action_name
              when "open_questionnaire","old_birkmanid_help","get_question_set","save_test_one_questions","save_test_two_questions","save_test_three_questions", "save_citizenship","save_work_env_questions", "verify_birkman_id"
                return false
              else
                return "registration"
          end
    end

    def generate_birkman_key
            @xml_post = form_birkman_key_xml(session[:job_seeker])
            url = URI.parse('https://api.birkman.com/xml-3.0-create.php')
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            response = http.post(url.path, @xml_post,"content-type"=>"text/xml")
            birkman_hash = parse_process_assessment_order_xml_content(response.body)
            if birkman_hash[:error].blank?
                form_birkman_detail_objects()
                @job_seeker_birkman_detail.unique_identifier = birkman_hash[:unique_identifier]
                @job_seeker_birkman_detail.birkman_user_id = birkman_hash[:birkman_user_id]
                @job_seeker_birkman_detail.save(:validate => false)
            end
    end

    def form_birkman_key_xml(job_seeker)
        redirect_url = "http://#{request.env['HTTP_HOST']}/questionnaire/return_from_birkman"
        language_code = "en-US"
        time_obj = Time.now
        creation_date_time = time_obj.strftime("%Y-%m-%d") + "T" + time_obj.strftime("%H:%M:%S") + "-06:00"
        api_key = BIRKMAN_API_KEY
        user_email = job_seeker.email

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
                #@e  = e
                birkman_hash[:error] = "Failed to initialize Birkman"
          end
          return birkman_hash
    end

    def verify_xml(user_birkman_key, first_name, last_name, email)
       time_obj = Time.now
       creation_date_time = time_obj.strftime('%Y-%m-%d') + 'T' + time_obj.strftime('%H:%M:%S') + '-06:00'
       api_key = BIRKMAN_API_KEY

       #~ user_birkman_key = 'D00108'
       #~ first_name = 'Hector'
       #~ last_name = 'Sample'
       #~ email = 'dsteckbeck@birkman.com'

       return xml = "<?xml version='1.0' encoding='UTF-8'?>
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
end