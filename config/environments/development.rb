# coding: UTF-8

Hilo::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  
  config.action_controller.perform_caching = false
  
  config.action_mailer.default_url_options = { :host => 'http://107.21.238.149/' }
  
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  #config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.cache_store = :redis_store
  
  ################## start -  paypal details ##################################
  config.after_initialize do
    PAYPAL_ACCOUNT = 'karan._1317296535_biz@globallogic.com'  
    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::Base.gateway_mode = :test
  end

  $PAYPAL_API_LOGIN = 'karan._1317296535_biz_api1.globallogic.com'
  $PAYPAL_API_PASSWORD = '1317296586'
  $PAYPAL_API_KEY = 'A7J5RiRErM-ESp2XyTGV04uP4-xgApspaIgPFTnp4QDZhXt4Gy2uDxF4'

  ################## end -  paypal details ##################################

  $BIRKMAN_MODE = "testmode"

  $TWITTER_CONSUMER_KEY = '955WnxL8P5BofoyNCmNCMg'
  $TWITTER_CONSUMER_SECRET = 'VAdaJBEmVDrNb6xlDPqiW3M4NjraTq8x8BPa3zV2DU'

  $LINKEDIN_CONSUMER_KEY = 'kGafZ5q1F3DjzCilSr7aqRbZ3RtbEJ4U-wJ2akwbuoSA2uDeM9lY_0A5hFT6YtR4'

  $LINKEDIN_CONSUMER_SECRET = 'Po61biVd7b4z2SpiP5RS4e1ODoSZbYfKJYrMEV62rkabee207cET-Dhm_bBVXbwd'

  $BITLY_KEY = 'karan108'
  $BITLY_SECRET = 'R_1f2145cee601672768d66416d116217d'

  config.action_mailer.delivery_method = :sendmail

  # Webengage Feedback System Key
  $WEBENGAGE_LICENSE_CODE = "~71680a96"

  $GOOGLE_ANALYTICS_ID = "UA-35169417-1"

  $FAYE_URL = "hilofaye.herokuapp.com/faye"

  $IMPORT_JOB_COMPANY_ID = 1

  $ENABLE_LANGUAGE_LOCALIZATION = 0
end
