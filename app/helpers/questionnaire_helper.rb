# coding: UTF-8

module QuestionnaireHelper

  #~ def show_hide_links_on_status(job_seeker_birkman_detail,state)
        #~ if state == "complete" 
             #~ if !job_seeker_birkman_detail.blank? and job_seeker_birkman_detail.test_complete == true
                #~ return ""
            #~ else
                #~ return "display:none;"
            #~ end
        #~ end
      
        
        #~ if state == "incomplete"
            #~ if job_seeker_birkman_detail.blank? or job_seeker_birkman_detail.test_complete == false
                #~ return ""
            #~ else
                #~ return "display:none;"
            #~ end
        #~ end
  #~ end

  def step_no_class(current_step, step_no)
      return (current_step.to_i == step_no.to_i) ? "current-step" : ""
  end
  
  def start_questionnaire_image(job_seeker_birkman_detail)
    return  (job_seeker_birkman_detail.blank? ? "begin_questionnaire.png" : "resume_questionnaire.png")
  end
  
end
