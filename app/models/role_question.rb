# coding: UTF-8

class RoleQuestion < ActiveRecord::Base
    attr_accessible :question, :xscoring, :yscoring, :order
    def self.question_list
        find(:all)
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
            img_str = "role_noimage.png"
        else
            img_str = "role_" + section + ".png"
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
