# coding: UTF-8

class DownloadFileController < ApplicationController
  require 'csv'
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  
  # Used to download Resume , called from employee_account/seeker_profile_popup and career_seeker
  def resume
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    @job_seeker = JobSeeker.where(:id=>params[:id]).first
    if File.exists?("#{Rails.root}/public#{@job_seeker.resume.url}")
      send_file "#{Rails.root}/public#{@job_seeker.resume.url}",
        :type => "#{@job_seeker.resume_content_type}",
        :disposition => 'attachment'
    else
      render :text => "File Not Found"
      return nil
    end
  end

  def additional_details
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    job_attachment = JobAttachment.includes(:job).find(params[:id])
    if File.exists?("#{Rails.root}/public/#{job_attachment.attachment.url}")
      send_file "#{Rails.root}/public/#{job_attachment.attachment.url}",
        :type => "#{job_attachment.attachment_content_type}",
        :disposition => 'attachment'
    else
      render :text => "File Not Found"
      return nil
    end
  end
  
  def download_cfg
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    if params[:name] == "eric"
      file_name = "#{Rails.root}/app/assets/public/about_hilo_CFG/CFG_ansley_eric.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"CFG_ansley_eric.pdf"
    elsif params[:name] == "chris"
      file_name = "#{Rails.root}/app/assets/public/about_hilo_CFG/Getner-CFG.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"Getner-CFG.pdf"
    elsif params[:name] == "lisa"
      file_name = "#{Rails.root}/app/assets/public/about_hilo_CFG/CFG_lisa.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"CFG_lisa.pdf"
    elsif params[:name] == "patrick"
      file_name = "#{Rails.root}/app/assets/public/about_hilo_CFG/CFG_patrick.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"CFG_patrick.pdf"
    elsif params[:name] == "michael"
      file_name = "#{Rails.root}/app/assets/public/about_hilo_CFG/CFG_turri_michael.pdf"
      send_file file_name, :type => 'application/pdf', :disposition => 'attachment',:filename=>"CFG_turri_michael.pdf"
    end
  end

  def download_payment_history
    @payment_list = Payment.where(:job_seeker_id=>session[:job_seeker].id).order("created_at DESC").all

    csv_report = CSV.generate do |csv|
      cols = ["DATE", "JOB CODE", "TYPE", "AMOUNT"]
      csv << cols

      @payment_list.each do |history|
        @time = history.created_at.to_date.strftime("%d/%m/%Y")
        if history.payment_purpose=="seeker_registration" or history.payment_purpose=="gift"
          @payment_purpose = "NA"
        else
          @payment_purpose = "HL #{history.job_id}"
        end
        @payment_purpose = ApplicationHelper.payment_text_type(history.payment_purpose)
        @amount = number_to_currency(history.amount_charged, :unit=>"")

        csv << [@time, @payment_purpose, @payment_purpose, @amount]
      end
    end

    # Fix for IE-8
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    # Fix for IE-8 ends here
    send_data(csv_report, :type => 'text/csv; charset=utf-8; header=present', :filename => "PaymentHistory.csv")
  end

  def download_payment_history_emp
    condition = Employer.find(session[:employer].id).subtree_ids.join(',')
    @payment_list = Payment.where("employer_id IN (#{condition})").order("created_at DESC").all

    csv_report = CSV.generate do |csv|
      cols = ["DATE", "USER", "JOB CODE", "CD ID", "AMOUNT"]
      csv << cols

      @payment_list.each do |history|
        @time = history.created_at.to_date.strftime("%d/%m/%Y")
        display_name = history.employer.first_name+" "+ApplicationHelper.initial_finder_emp(history.employer.last_name)
        @user = truncate(display_name, :length => 10, :omission => '...')
        if history.payment_purpose=="seeker_registration" or history.payment_purpose=="gift"
          @job_code = "NA"
        else
          @job_code = "HL #{history.job_id}"
        end
        if history.profile_id.nil?
          @cd_id = "NA"
        else
          @cd_id = "CS"
        end
        @amount = number_to_currency(history.amount_charged, :unit=>"")

        csv << [@time, @user, @job_code, @cd_id, @amount]
      end
    end

    # Fix for IE-8
    response.headers.delete("Pragma")
    response.headers.delete('Cache-Control')
    # Fix for IE-8 ends here
    send_data(csv_report, :type => 'text/csv; charset=utf-8; header=present', :filename => "PaymentHistory.csv")
  end
end