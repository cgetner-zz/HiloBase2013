# coding: UTF-8

class JobSeekerWorkenvQuestion < ActiveRecord::Base
  attr_accessible :job_seeker_id, :workenv_question_id, :score
  belongs_to :job_seeker
  
  def self.save_workenv_for_jobseeker(val_str, seeker_id, save_type)
      job_seeker = JobSeeker.find(seeker_id)
      val_arr = val_str.split(",")
      work_questions = WorkenvQuestion.seeker_next_questions_for_work_env(job_seeker.job_seeker_birkman_detail)
      work_questions.each_with_index{|obj , i|
            jswq = JobSeekerWorkenvQuestion.find(:first,:conditions=>["job_seeker_id = ? and workenv_question_id = ?",seeker_id,obj.id])
            if jswq.nil?
              jswq = JobSeekerWorkenvQuestion.new({:job_seeker_id => seeker_id, :workenv_question_id => obj.id, :score => val_arr[i]})
            else
              jswq.score = val_arr[i]
            end
            jswq.save(:validate => false)
      }
      if save_type == "return_later"
        
      else
        job_seeker_birkman_detail = job_seeker.job_seeker_birkman_detail
        job_seeker_birkman_detail.responded_birkman_question_id = work_questions.last.id
        if job_seeker_birkman_detail.responded_birkman_question_id == 10
          job_seeker_birkman_detail.responded_birkman_question_id = ""
        end
        job_seeker_birkman_detail.responded_birkman_set_number = BIRKMAN_STEP_WORKENV if work_questions.last.id == 10
        job_seeker_birkman_detail.save(:validate => false)
        if job_seeker_birkman_detail.pass_through and work_questions.last.id == 10
          job_seeker_birkman_detail.test_complete = true
          job_seeker_birkman_detail.save(:validate => false)
        end
      end
  end
  
end
