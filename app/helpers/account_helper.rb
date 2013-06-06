# coding: UTF-8

module AccountHelper

  def birkman_report_file_size
       file_name = "#{Rails.root}/#{BIRKMAN_PDF_PATH}/#{session[:job_seeker].id}_birkman_report.pdf"
        if File.exists?(file_name)
            return "File Size: #{number_to_human_size(File.size("#{Rails.root}/#{BIRKMAN_PDF_PATH}/#{session[:job_seeker].id}_birkman_report.pdf"))}"
        else
            return ""
        end
  end

  def show_job_on_load
      if session[:show_job]
          str =  "eval(\"show_job.call(#{session[:show_job]},'via_share');\")"
          session[:show_job]  = nil
          return str
      end
  end
  
end
