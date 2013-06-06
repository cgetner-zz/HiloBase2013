class JobAttachment < ActiveRecord::Base
  attr_accessible :job_id, :attachment, :attachment_file_name, :attachment_file_size, :attachment_content_type, :attachment_title
  audited

  belongs_to :job

  has_attached_file :attachment,
    :url  => "/system/attachment/:job_id/:basename.:extension",
    :path => "#{Rails.root}/public/system/attachment/:job_id/:basename.:extension"
  validates_attachment_size :attachment, :less_than => 5.megabytes
  validates_attachment_content_type :attachment, :content_type => ['application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/msword']
  validates_format_of :attachment_file_name, :with => %r{\.(docx|doc|pdf)$}i

  include Rails.application.routes.url_helpers

  before_create :randomize_file_name

  Paperclip.interpolates :job_id do |attachment, style|
   return attachment.instance.job_id
  end

  searchable :auto_index => false do
    attachment :document_attachment
  end

private

  def randomize_file_name
    extension = File.extname(attachment_file_name).downcase
    file_name = File.basename(attachment_file_name, File.extname(attachment_file_name).downcase)
    new_file_name = "#{file_name}_#{SecureRandom.random_number(100)}"
    self.attachment.instance_write(:file_name, "#{new_file_name}#{extension}")
  end

  def document_attachment
    "#{Rails.root}/public/#{self.attachment.url}"
  end
end