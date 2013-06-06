# coding: UTF-8

Hilo::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.action_mailer.default_url_options = { :host => 'http://107.21.238.149/' }
  
  config.consider_all_requests_local       = false
  
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
   config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5


# PAYPAL STAGING
config.after_initialize do
    PAYPAL_ACCOUNT = 'karan._1317296535_biz@globallogic.com'
    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::Base.gateway_mode = :test
end
$PAYPAL_API_LOGIN = 'karan._1317296535_biz_api1.globallogic.com'
$PAYPAL_API_PASSWORD = '1317296586'
$PAYPAL_API_KEY = 'A7J5RiRErM-ESp2XyTGV04uP4-xgApspaIgPFTnp4QDZhXt4Gy2uDxF4'
# PAYPAL STAGING # END

# BIRKMAN
$BIRKMAN_MODE = "Production"
# BIRKMAN # END

# TWITTER STAGING
$TWITTER_CONSUMER_KEY = 'uI7Q5TiOWR75oqAAGhCRQ'
$TWITTER_CONSUMER_SECRET = 'MXyIzx6eI5yeQNe8kjrMaN2wrzFhQdcBwvwUPFXUh8'
# TWITTER STAGING END

# LINKEDIN STAGING
$LINKEDIN_CONSUMER_KEY = 'U2qWUb6oVggPomYtAHf91Fh5ihpSicEG8JlDqOiBDQPyxYKEj4OGuAngCD1tNSwk'
$LINKEDIN_CONSUMER_SECRET = '5bA6cOD960E1DxrjsQjHgr5-fbl2vttU5-T4maV-Q96FwYVyRZPMCteO9YleIfAg'
# LINKEDIN STAGING END

# BITLY STAGING
$BITLY_KEY = 'karan108'
$BITLY_SECRET = 'R_1f2145cee601672768d66416d116217d'
# BITLY STAGING END

end
