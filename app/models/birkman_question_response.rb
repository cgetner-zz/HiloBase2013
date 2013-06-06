# coding: UTF-8

class BirkmanQuestionResponse < ActiveRecord::Base
  attr_accessible :job_seeker_id, :birkman_question_id, :response
  belongs_to :job_seeker
  
  def self.save_test_one_response(response_str, seeker_id, save_type)
    resp_arr = response_str.split(",")
    job_seeker = JobSeeker.find(seeker_id)
    job_seeker_birkman_detail = job_seeker.job_seeker_birkman_detail
      
    birkman_questions = self.seeker_next_questions_for_set_one(job_seeker_birkman_detail)
      
    birkman_questions.each_with_index{|obj,i|
      object = BirkmanQuestionResponse.find(:first,:conditions=>["job_seeker_id = ? and birkman_question_id = ?",seeker_id,obj.id])
      if object.nil?
        object = BirkmanQuestionResponse.new({:job_seeker_id => seeker_id, :birkman_question_id => obj.id, :response => resp_arr[i]}).save(:validate => false)
      else
        object.response = resp_arr[i]
        object.save(:validate => false)
      end
    }
      
    if save_type == "return_later"
      
    else
      job_seeker_birkman_detail.responded_birkman_question_id = birkman_questions.last.id
        
      if birkman_questions.last.id.to_i == BIRKMAN_SET_ONE_LAST_ID.to_i
        job_seeker_birkman_detail.responded_birkman_set_number = BIRKMAN_STEP_TEST_ONE
      end
        
      job_seeker_birkman_detail.save(:validate => false)
    end
      
  end
  

  def self.save_test_two_response(response_str, seeker_id, save_type)
    resp_arr = response_str.split(",")
    job_seeker = JobSeeker.find(seeker_id)
    job_seeker_birkman_detail = job_seeker.job_seeker_birkman_detail
      
    birkman_questions = self.seeker_next_questions_for_set_two(job_seeker_birkman_detail)
      
    birkman_questions.each_with_index{|obj,i|
        
      object = BirkmanQuestionResponse.find(:first,:conditions=>["job_seeker_id = ? and birkman_question_id = ?",seeker_id,obj.id])
      if object.nil?
        object = BirkmanQuestionResponse.new({:job_seeker_id => seeker_id, :birkman_question_id => obj.id, :response => resp_arr[i]}).save(:validate => false)
      else
        object.response = resp_arr[i]
        object.save(:validate => false)
      end
    }
      
    if save_type == "return_later"
        
    else
      job_seeker_birkman_detail.responded_birkman_question_id = birkman_questions.last.id
        
      if birkman_questions.last.id.to_i == BIRKMAN_SET_TWO_LAST_ID.to_i
        job_seeker_birkman_detail.responded_birkman_question_id = 0
        job_seeker_birkman_detail.responded_birkman_set_number = BIRKMAN_STEP_TEST_TWO
      end
        
      job_seeker_birkman_detail.save(:validate => false)
    end
      
  end
  
  
  def self.seeker_next_questions_for_set_one(job_seeker_birkman_detail)
    BirkmanQuestion.find(:all,:conditions=>["id > ? and set_number = 2",job_seeker_birkman_detail.responded_birkman_question_id.to_i],:limit=>"0,10",:order=>"id ASC")
  end    
    
  def self.seeker_next_questions_for_set_two(job_seeker_birkman_detail)
    BirkmanQuestion.find(:all,:conditions=>["id > ? and set_number = 3",job_seeker_birkman_detail.responded_birkman_question_id.to_i],:limit=>"0,10",:order=>"id ASC")
  end
  
end
