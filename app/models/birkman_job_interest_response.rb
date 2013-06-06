# coding: UTF-8

class BirkmanJobInterestResponse < ActiveRecord::Base
  attr_accessible :birkman_job_interest_id, :job_seeker_id, :choice
  belongs_to :job_seeker
  def self.seeker_next_questions_for_set_three(job_seeker_birkman_detail)
    if job_seeker_birkman_detail.responded_birkman_set_number.to_i == BIRKMAN_STEP_TEST_TWO.to_i and job_seeker_birkman_detail.responded_birkman_question_id == 0
      return BirkmanJobInterest.find(:all,:limit=>"0,4",:order=>"id ASC")
    else
      return BirkmanJobInterest.find(:all,:conditions=>["id > ?",job_seeker_birkman_detail.responded_birkman_question_id.to_i],:limit=>"0,4",:order=>"id ASC")
    end
  end
    
    
  def self.save_test_three_response(job_seeker_birkman_detail,job_seeker_id,first_choice,second_choice,save_type)
    birkman_questions = BirkmanJobInterestResponse.seeker_next_questions_for_set_three(job_seeker_birkman_detail)
          
    birkman_questions.each_with_index{|obj,i|
      object = BirkmanJobInterestResponse.find(:first,:conditions=>["birkman_job_interest_id = ? and job_seeker_id = ?",obj.id,job_seeker_id])
      if not object.nil?
        object.delete
      end
    }
          
          
    if not first_choice == 0
      object = BirkmanJobInterestResponse.find(:first,:conditions=>["birkman_job_interest_id = ? and job_seeker_id = ?",birkman_questions[first_choice - 1].id,job_seeker_id])
      if object.nil?
        BirkmanJobInterestResponse.create({
            :birkman_job_interest_id => birkman_questions[first_choice - 1].id,
            :job_seeker_id => job_seeker_id,
            :choice => "first"
          })
      else
        object.choice = "first"
        object.save(:validate => false)
      end
    end
          
    if not second_choice == 0
      object = BirkmanJobInterestResponse.find(:first,:conditions=>["birkman_job_interest_id = ? and job_seeker_id = ?",birkman_questions[second_choice - 1].id,job_seeker_id])
      if object.nil?
        BirkmanJobInterestResponse.create({
            :birkman_job_interest_id => birkman_questions[second_choice - 1].id,
            :job_seeker_id => job_seeker_id,
            :choice => "second"
          })
      else
        object.choice = "second"
        object.save(:validate => false)
      end
    end

    if save_type == "return_later"
        
    else
      job_seeker_birkman_detail.responded_birkman_question_id = birkman_questions.last.id
            
            
      birkman_test_complete = false
      if birkman_questions.last.id.to_i == BIRKMAN_SET_THREE_LAST_ID.to_i
        birkman_test_complete = true
        job_seeker_birkman_detail.test_complete = true
        job_seeker_birkman_detail.responded_birkman_set_number = BIRKMAN_STEP_TEST_THREE
        job_seeker = JobSeeker.find(job_seeker_id)
        job_seeker.completed_registration_step = QUESTIONNAIRE_STEP
        job_seeker.save(:validate => false)
      end
      job_seeker_birkman_detail.save(:validate => false)
    end
    return birkman_test_complete
  end
end
