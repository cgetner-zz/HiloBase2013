# coding: UTF-8
# Important Note: Please don't run this command on the fresh machine or on the fresh server. Run only when document_id failed to generate for a Seeker.

require 'net/http'
require 'uri'

namespace :generate_document_id do
    desc "Generate document Id for job seeker Annie"
    task(:data=> :environment) do
        def generate_document_id
            @job_seeker = JobSeeker.find_by_id(105)
            if @job_seeker
              @job_seeker_birkman_detail = @job_seeker.job_seeker_birkman_detail
              if @job_seeker_birkman_detail.unique_identifier.blank?
                @xml_post = form_birkman_key_xml(@job_seeker)
                url = URI.parse('https://api.birkman.com/xml-3.0-create.php')
                http = Net::HTTP.new(url.host, url.port)
                http.use_ssl = true
                @response = http.post(url.path, @xml_post,"content-type"=>"text/xml")
                birkman_hash = parse_process_assessment_order_xml_content(@response.body)
                if birkman_hash[:error].blank?
                  @job_seeker_birkman_detail.update_attributes(:unique_identifier => birkman_hash[:unique_identifier], :birkman_user_id => birkman_hash[:birkman_user_id])
                else
                  puts "Failed to update job seeker Annie"
                end
              else
                puts "Job Seeker Annie doesn't have a blank unique id"
              end
            else
              puts "Couldn't find job seeker with the appropriate Id"
            end
        end

        def form_birkman_key_xml(job_seeker)
          redirect_url = "https://thehiloproject.com/questionnaire/return_from_birkman"
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
        generate_document_id()
    end
end