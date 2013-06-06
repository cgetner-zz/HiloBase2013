# coding: UTF-8

class WorkenvQuestion < ActiveRecord::Base
    attr_accessible :question, :xscoring, :yscoring, :description_left, :description_right, :for_emp, :order
    translates :question, :description_left, :description_right
    def self.seeker_next_questions_for_work_env(job_seeker_birkman_detail)
      WorkenvQuestion.find(:all,:conditions=>["id > ? AND for_emp = ?",job_seeker_birkman_detail.responded_birkman_question_id.to_i, 0],:limit=>"0,5",:order=>"id ASC")
    end

    # For guest job seeker
    def self.guest_job_seeker_next_questions_for_work_env(job_seeker_birkman_detail)
      WorkenvQuestion.find(:all,:conditions=>["id > ? AND for_emp = ?", job_seeker_birkman_detail.responded_birkman_question_id.to_i, 0],:limit=>"0,5",:order=>"id ASC")
    end

    #for employers
    def self.question_list
        where("for_emp = 1").all
    end
    
    def self.section_by_score(x_score,y_score)
        if x_score.blank? or y_score.blank?
          return "void"
        end
        
        section_str = ""
        if x_score == -1 and y_score == -1
            section_str = "void"
        elsif x_score <= 49 and y_score <= 49
            section_str = "bottom_left"
        elsif x_score > 49 and y_score <= 49
            section_str = "bottom_right"
        elsif x_score <= 49 and y_score > 49
            section_str = "top_left"
        else  
            section_str = "top_right"
        end
        return section_str
    end
    
    
    def self.image_by_score(x_score,y_score)
        section = self.section_by_score(x_score,y_score)
        if section == "void"
            img_str = "workenv_noimage.png"
        else
            img_str = "workenv_" + section + ".png"
        end
        return img_str
    end
    
    
    def self.text_and_color_by_score(x_score,y_score)
        section = self.section_by_score(x_score,y_score)
        case section
            when "bottom_left"
                return "analyzer","yellow"
            when "bottom_right"
                return "thinker","blue"
            when "top_left"
                return "doer","red"
            when "top_right"
                return "communicator","green" 
            else
                return "",""
        end
    end
    
    def self.text_by_score(x_score,y_score)
        section = self.section_by_score(x_score,y_score)
        case section
            when "bottom_left"
                return "analyzer"
            when "bottom_right"
                return "thinker"
            when "top_left"
                return "doer"
            when "top_right"
                return "communicator"
            else
                return ""
        end
    end
   
end