# coding: UTF-8

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120426093559) do

  create_table "admins", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "hashed_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerts", :force => true do |t|
    t.integer  "job_seeker_id"
    t.text     "text"
    t.string   "url"
    t.boolean  "deleted",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "birkman_job_interest_responses", :force => true do |t|
    t.integer  "birkman_job_interest_id"
    t.integer  "job_seeker_id"
    t.string   "choice",                  :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "birkman_job_interests", :force => true do |t|
    t.string   "statement"
    t.integer  "set_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "birkman_question_responses", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "birkman_question_id"
    t.boolean  "response",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "birkman_questions", :force => true do |t|
    t.string   "question"
    t.integer  "set_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activated",  :default => false
    t.integer  "created_by"
    t.string   "user_type"
  end

  create_table "channel_managers", :force => true do |t|
    t.integer  "job_id"
    t.integer  "facebook_count", :default => 0
    t.integer  "linkedin_count", :default => 0
    t.integer  "twitter_count",  :default => 0
    t.integer  "url_count",      :default => 0
    t.integer  "hilo_count",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coderequests", :force => true do |t|
    t.string   "email"
    t.integer  "promotional_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_one"
    t.string   "street_two"
    t.string   "city"
    t.string   "zip"
    t.integer  "state_id"
    t.string   "phone"
    t.string   "fax"
    t.string   "founded_in"
    t.integer  "employee_strength"
    t.string   "website"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "other_link_one"
    t.string   "other_link_two"
    t.integer  "owner_ship_type_id"
    t.string   "ticker_value"
    t.integer  "created_by"
    t.string   "country"
    t.string   "state"
  end

  create_table "company_groups", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",    :default => false
    t.integer  "sort_index"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "alpha2"
    t.string   "alpha3"
    t.integer  "numeric"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creative_samples", :force => true do |t|
    t.string   "type"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.string   "url",                 :limit => 500
    t.integer  "job_seeker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption"
  end

  create_table "degrees", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "desired_employments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "desired_locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employer_alerts", :force => true do |t|
    t.integer  "job_id"
    t.integer  "job_seeker_id"
    t.string   "purpose"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "new",           :default => true
  end

  create_table "employer_view_job_seekers", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "employer_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employers", :force => true do |t|
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "phone_one"
    t.string   "phone_two"
    t.string   "contact_email"
    t.string   "zip_code"
    t.string   "preferred_contact"
    t.integer  "completed_registration_step"
    t.boolean  "activated",                   :default => false
    t.integer  "role_id"
    t.string   "fpwd_code"
    t.datetime "last_login"
    t.integer  "emp_admin"
    t.boolean  "advanced_alert",              :default => false
  end

  create_table "gifts", :force => true do |t|
    t.string   "sender_name"
    t.string   "sender_email"
    t.string   "recipient_email"
    t.text     "mail_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "promotional_code_id"
    t.string   "recipient_name"
  end

  create_table "job_criteria_certificates", :force => true do |t|
    t.integer  "job_id"
    t.integer  "certificate_id"
    t.boolean  "required_flag",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_criteria_degrees", :force => true do |t|
    t.integer  "job_id"
    t.integer  "degree_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_criteria_desired_employments", :force => true do |t|
    t.integer  "job_id"
    t.integer  "desired_employment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_criteria_desired_locations", :force => true do |t|
    t.integer  "job_id"
    t.integer  "desired_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_criteria_languages", :force => true do |t|
    t.integer  "job_id"
    t.integer  "language_id"
    t.string   "proficiency_val", :limit => 10
    t.boolean  "required_flag",                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_criteria_proficiencies", :force => true do |t|
    t.integer  "job_id"
    t.integer  "proficiency_id"
    t.string   "proficiency_val", :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_locations", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_one"
    t.string   "street_two"
    t.string   "city"
    t.string   "zip_code"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "state"
    t.string   "country"
  end

  create_table "job_profile_responsibilities", :force => true do |t|
    t.integer  "job_id"
    t.integer  "profile_responsibility_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_role_questions", :force => true do |t|
    t.integer  "role_question_id"
    t.integer  "job_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_awards", :force => true do |t|
    t.integer  "job_seeker_id"
    t.string   "title",               :limit => 500
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_birkman_details", :force => true do |t|
    t.integer  "job_seeker_id"
    t.string   "unique_identifier"
    t.string   "questionnaire_url"
    t.string   "birkman_user_id"
    t.string   "status"
    t.text     "last_log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "test_complete",                 :default => false
    t.boolean  "pdf_saved",                     :default => false
    t.integer  "grid_work_environment_x"
    t.integer  "grid_work_environment_y"
    t.integer  "grid_work_role_x"
    t.integer  "grid_work_role_y"
    t.integer  "responded_birkman_question_id"
    t.integer  "responded_birkman_set_number"
    t.boolean  "us_citizen",                    :default => false
    t.boolean  "test_submitted",                :default => false
    t.boolean  "pass_through",                  :default => false
    t.string   "pass_first_name"
    t.string   "pass_last_name"
    t.string   "pass_email"
    t.string   "pass_birkman_code"
  end

  create_table "job_seeker_certificates", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "certificate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_certifications", :force => true do |t|
    t.integer  "job_seeker_id"
    t.string   "title"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_degrees", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "degree_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_desired_employments", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "desired_employment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_desired_locations", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "desired_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pincode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "city"
  end

  create_table "job_seeker_education_levels", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "education_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_follow_companies", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_languages", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "language_id"
    t.string   "proficiency_val", :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_links", :force => true do |t|
    t.integer  "job_seeker_id"
    t.text     "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_notifications", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "notification_type_id"
    t.integer  "notification_message_id"
    t.boolean  "visibility"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "new",                     :default => true
    t.integer  "job_id"
    t.integer  "company_id"
  end

  create_table "job_seeker_proficiencies", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "proficiency_id"
    t.string   "proficiency_val", :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "education_id"
    t.integer  "skill_id"
  end

  create_table "job_seeker_skill_levels", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "skill_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_watchlists", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seeker_workenv_questions", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "workenv_question_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_seekers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "hashed_password"
    t.string   "phone_one"
    t.string   "phone_two"
    t.string   "contact_email"
    t.boolean  "activated",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "completed_registration_step"
    t.float    "minimum_compensation_amount", :default => 0.0
    t.integer  "desired_paid_offs",           :default => 0
    t.integer  "desired_commute_radius",      :default => 0
    t.integer  "work_exp_value",              :default => 0
    t.string   "video_url"
    t.text     "summary"
    t.string   "preferred_contact"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.string   "zip_code"
    t.string   "fpwd_code"
    t.datetime "last_login"
    t.boolean  "armed_forces",                :default => false
    t.string   "area_code"
    t.integer  "js_admin"
    t.string   "website_one"
    t.string   "website_two"
    t.string   "website_three"
    t.string   "website_title_one"
    t.string   "website_title_two"
    t.string   "website_title_three"
    t.boolean  "follow_check",                :default => false
    t.string   "city"
    t.boolean  "advanced_alert",              :default => false
    t.string   "track_shared_job_id"
    t.string   "bridge_response"
  end

  create_table "job_statuses", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "job_id"
    t.boolean  "follow"
    t.boolean  "read"
    t.boolean  "considering"
    t.boolean  "interested"
    t.boolean  "wild_card"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",      :default => false
    t.datetime "considered_on"
    t.datetime "interested_on"
    t.datetime "wildcard_on"
    t.datetime "read_on"
  end

  create_table "job_workenv_questions", :force => true do |t|
    t.integer  "workenv_question_id"
    t.integer  "job_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "position"
    t.integer  "job_location_id"
    t.datetime "expire_at"
    t.integer  "employer_id"
    t.integer  "marks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
    t.integer  "company_group_id"
    t.boolean  "active",                      :default => false
    t.string   "photoone_file_name"
    t.string   "photoone_content_type"
    t.string   "photoone_file_size"
    t.string   "phototwo_file_name"
    t.string   "phototwo_content_type"
    t.string   "phototwo_file_size"
    t.float    "minimum_compensation_amount", :default => 0.0
    t.integer  "desired_paid_offs",           :default => 0
    t.integer  "desired_commute_radius",      :default => 0
    t.integer  "work_exp_value",              :default => 0
    t.boolean  "basic_complete",              :default => false
    t.boolean  "credential_complete",         :default => false
    t.boolean  "personality_work_complete",   :default => false
    t.boolean  "personality_role_complete",   :default => false
    t.boolean  "overview_complete",           :default => false
    t.boolean  "detail_preview",              :default => false
    t.integer  "grid_work_environment_x"
    t.integer  "grid_work_environment_y"
    t.integer  "grid_work_role_x"
    t.integer  "grid_work_role_y"
    t.integer  "company_id"
    t.boolean  "deleted",                     :default => false
    t.integer  "sort_index"
    t.boolean  "profile_complete",            :default => false
    t.boolean  "remote_work"
    t.boolean  "armed_forces",                :default => true
    t.text     "overview"
    t.boolean  "hiring_company",              :default => true
    t.string   "hiring_company_name"
    t.string   "website_one"
    t.string   "website_two"
    t.string   "website_three"
    t.string   "website_title_one"
    t.string   "website_title_two"
    t.string   "website_title_three"
    t.string   "attachment_file_name"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.string   "attachment_title"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_job_shares", :force => true do |t|
    t.integer  "job_id"
    t.integer  "share_platform_id"
    t.integer  "job_seeker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_shares", :force => true do |t|
    t.integer  "job_id"
    t.integer  "share_platform_id"
    t.integer  "job_seeker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_messages", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link",       :default => "javascript:void(0)"
  end

  create_table "notification_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owner_ship_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pairing_logics", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "job_id"
    t.float    "pairing_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.float    "amount_charged"
    t.string   "id_of_transaction"
    t.string   "paypal_status"
    t.text     "log_message"
    t.boolean  "payment_success"
    t.text     "billing_address_one"
    t.text     "billing_address_two"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip"
    t.string   "billing_country"
    t.string   "payment_purpose"
    t.integer  "promotional_code_id"
    t.string   "payment_mode"
    t.string   "payer_id"
    t.string   "token_value"
    t.integer  "job_seeker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employer_id"
    t.string   "company_name"
    t.float    "paypal_amount"
    t.float    "promotional_code_amount"
    t.string   "id_billing_agreement"
    t.integer  "job_id"
    t.string   "card_number"
    t.integer  "profile_id"
    t.string   "billing_contact"
    t.string   "card_type"
  end

  create_table "postings", :force => true do |t|
    t.boolean  "hilo_share"
    t.boolean  "facebook_share"
    t.boolean  "linkedin_share"
    t.boolean  "twitter_share"
    t.integer  "job_id"
    t.integer  "employer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hilo_count",     :default => 0
    t.integer  "facebook_count", :default => 0
    t.integer  "twitter_count",  :default => 0
    t.integer  "linkedin_count", :default => 0
    t.integer  "url_count",      :default => 0
    t.boolean  "url_share"
  end

  create_table "proficiencies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activated",  :default => false
    t.integer  "created_by"
  end

  create_table "profile_responsibilities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promotional_code_details", :force => true do |t|
    t.integer  "promotional_code_id"
    t.string   "source_name"
    t.datetime "origination"
    t.datetime "expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promotional_codes", :force => true do |t|
    t.text     "code"
    t.integer  "job_seeker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "amount"
    t.integer  "employer_id"
    t.boolean  "given",           :default => false
    t.float    "consumed_amount", :default => 0.0,   :null => false
    t.string   "origination"
  end

  create_table "purchased_profiles", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "employer_id"
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
  end

  create_table "references", :force => true do |t|
    t.string   "name"
    t.string   "position"
    t.string   "company"
    t.string   "email"
    t.text     "comments"
    t.integer  "job_seeker_id"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_questions", :force => true do |t|
    t.string   "question"
    t.string   "xscoring",   :limit => 5
    t.string   "yscoring",   :limit => 5
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.text     "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "share_platforms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skill_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonials", :force => true do |t|
    t.string   "testimonial_by"
    t.string   "name"
    t.string   "position"
    t.string   "description"
    t.boolean  "display",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workenv_questions", :force => true do |t|
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "question"
    t.string   "xscoring",          :limit => 5
    t.string   "yscoring",          :limit => 5
    t.text     "description_left"
    t.text     "description_right"
    t.boolean  "for_emp"
  end

  create_table "zipcodes", :force => true do |t|
    t.integer  "zip"
    t.string   "zipcodetype"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
