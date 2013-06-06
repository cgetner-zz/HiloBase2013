# coding: UTF-8

class Gift < ActiveRecord::Base
  
#  validates :sender_name, :message=>"Sender name required", :presence=>true
#  validates :sender_email, :message=>"Sender email required", :presence=>true
#  validates :recipient_name, :message=>"Recipient's name required", :presence=>true
#  validates :recipient_email, :message=>"Recipient's email required", :presence=>true
#  validates :mail_text, :message=>"Message required", :presence=>true
#
#
#  validates_format_of :sender_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:message=>"Sender email is not valid", :if => :sender_email?
#  validates_format_of :recipient_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:message=>"Recipient email is not valid", :if => :recipient_email?
#
#  validates_confirmation_of :recipient_email,:if => Proc.new { |gift| !gift.recipient_email.blank? },:message=>"Confirm Recipient Email do not match"
 
has_one :promotional_code,:dependent => :destroy
  
end
