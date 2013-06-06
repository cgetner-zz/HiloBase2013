# coding: UTF-8

module MyIntroductionHelper


def display_required_message
  return (!session[:job_seeker].summary.blank? and !session[:job_seeker].resume_file_name.blank?) ? "display:none;" : ""
end

def link_values(obj_arr,index)
    str = ""
    if not obj_arr[index - 1].blank?
        str = obj_arr[index - 1].url
    end
    str
end

def link_descrition(obj_arr,index)
  str = ""
    if not obj_arr[index - 1].blank?
        str = obj_arr[index - 1].description
    end
    str
end

def contact_email_label(email)
    if email.length > 20
        str =  email.first(20) + "..<a href='javascript:void(0);' class='contactemail-title-menu small-link' data-email=\"#{CGI::escape(email)}\">more</a>"
    else
       str = email
    end
    return str
end
  
  
def cert_title(title)
    if title.length > 20
        str =  title.first(20) + "<a href='javascript:void(0);' class='cert-title-menu small-link' data-title=\"#{CGI::escape(title)}\">..more</a>"
    else
       str = title
    end
    return str
end

def sample_caption(caption)
    if caption.length > 20
        str =  caption.first(20) + "<a href='javascript:void(0);' class='sample-caption-menu small-link' data-caption=\"#{CGI::escape(caption)}\">..more</a>"
    else
       str = caption
    end
    return str
end


def intro_link(js_link)
  if js_link.description.length  > 120
      str = "<a href='#{js_link.url}' target='_blank' >#{js_link.description.first(120)}</a>" + "<a href='javascript:void(0);' class='link-desc-menu small-link' data-desc='#{CGI::escape(js_link.description)}'>..more</a>"
  else
      str = "<a href='#{js_link.url}' target='_blank' >#{js_link.description}</a>"
  end
  return str
end


def award_title(js_award)
    if js_award.upload_file_name.blank?
        if js_award.title.length > 160
             str = js_award.title.first(160) + "<a href='javascript:void(0);' class='award-menu small-link' data-award='#{CGI::escape(js_award.title)}' style='text-decoration:none;'>..more</a>"
        else
            str = js_award.title
        end
    else
        if js_award.title.length > 160
            str = "<a href='/download_file/award/#{js_award.id}' style='text-decoration:underline;'>#{js_award.title.first(160)}</a>" + "<a href='javascript:void(0);' class='award-menu small-link' data-award='#{CGI::escape(js_award.title)}' style='text-decoration:none;'>..more</a>"
        else
            str = "<a href='/download_file/award/#{js_award.id}' style='text-decoration:underline;'>#{js_award.title}</a>"
        end
    end
    return str
end

end
