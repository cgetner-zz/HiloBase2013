class GuestJobSeekerWorkenvQuestion < ActiveRecord::Base
  attr_accessible :guest_job_seeker_id, :workenv_question_id, :score

  def self.save_workenv_for_jobseeker(val_str, seeker_id)
    guest_job_seeker = GuestJobSeeker.find(seeker_id)
    val_arr = val_str.split(",")
    work_questions = WorkenvQuestion.guest_job_seeker_next_questions_for_work_env(guest_job_seeker)
    work_questions.each_with_index{|obj , i|
      jswq = GuestJobSeekerWorkenvQuestion.find(:first, :conditions=>["guest_job_seeker_id = ? and workenv_question_id = ?", seeker_id, obj.id])
      if jswq.nil?
        jswq = GuestJobSeekerWorkenvQuestion.new({:guest_job_seeker_id => seeker_id, :workenv_question_id => obj.id, :score => val_arr[i]})
      else
        jswq.score = val_arr[i]
      end
      jswq.save(:validate => false)
    }
    guest_job_seeker.responded_birkman_question_id = work_questions.last.id
    if guest_job_seeker.responded_birkman_question_id == 10
      guest_job_seeker.responded_birkman_question_id = ""
    end
    guest_job_seeker.responded_birkman_set_number = BIRKMAN_STEP_WORKENV if work_questions.last.id == 10
    guest_job_seeker.save(:validate => false)
    #if guest_job_seeker.pass_through and work_questions.last.id == 10
    if work_questions.last.id == 10
      guest_job_seeker.test_complete = true
      guest_job_seeker.save(:validate => false)
    end
  end
end