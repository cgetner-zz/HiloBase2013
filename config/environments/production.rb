# coding: UTF-8

Hilo::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false
  
  config.action_mailer.default_url_options = { :host => 'thehiloproject.com' }
 
  # Compress JavaScripts and CSS
  config.assets.compress = true
  
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.sendmail_settings = { :arguments => '-i' }
  config.action_mailer.perform_deliveries = true
  
  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true
  
  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( application.js, application_employer.js, birkman.js, common.js, custom_form_element.js, customdropdown.js, elementCheck.js, employer.js, employer_v2.js, excanvas.min.js, FancyZoom.js, jquery.autocomplete.js, jquery.caret.js, jquery.flot.js, jquery.flot.symbol.js, jquery.form.js, jquery.hoverIntent.js, jquery.numeric.js, main.js, myintro.js, pairing.js, scroll_effect.js, stylesheet.css, stylesheet-IE7.css, stylesheet-IE8.css, stylesheet-IE9.css, employer.css, employer_v2.css, employer_v2-IE7.css, employer_v2-IE8.css, employer_v2-IE9.css, jquery-ui-1.8.custom.css )

  # Enable threaded mode
  config.threadsafe! unless $rails_rake_task

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  # PAYPAL PRODUCTION
  config.after_initialize do
    PAYPAL_ACCOUNT = 'eric@thehiloproject.com'
    ActiveMerchant::Billing::Base.mode = :production
    ActiveMerchant::Billing::Base.gateway_mode = :production
  end

  $PAYPAL_API_LOGIN = 'ansleyeric_api1.mac.com'
  $PAYPAL_API_PASSWORD = 'S52TXZ5VEMTQTG5V'
  $PAYPAL_API_KEY = 'Akg3ujzP21SVY8o92OXr0DNfg-5XACzsgVXMy.sNb3svQGXENz9zsdel'
  # PAYPAL PRODUCTION # END

  # BIRKMAN
  $BIRKMAN_MODE = "Production"
  # BIRKMAN # END

  # TWITTER PRODUCTION
  $TWITTER_CONSUMER_KEY = 'uI7Q5TiOWR75oqAAGhCRQ'
  $TWITTER_CONSUMER_SECRET = 'MXyIzx6eI5yeQNe8kjrMaN2wrzFhQdcBwvwUPFXUh8'
  # TWITTER PRODUCTION END

  # LINKEDIN PRODUCTION
  $LINKEDIN_CONSUMER_KEY = 'U2qWUb6oVggPomYtAHf91Fh5ihpSicEG8JlDqOiBDQPyxYKEj4OGuAngCD1tNSwk'
  $LINKEDIN_CONSUMER_SECRET = '5bA6cOD960E1DxrjsQjHgr5-fbl2vttU5-T4maV-Q96FwYVyRZPMCteO9YleIfAg'
  # LINKEDIN PRODUCTION END

  # BITLY PRODUCTION
  $BITLY_KEY = 'cgetner'
  $BITLY_SECRET = 'R_9c8531d8b9037432fc51ba9df96f46f3'
  # BITLY PRODUCTION END

  # Webengage Feedback System Key
  $WEBENGAGE_LICENSE_CODE = "~99199146"

  $GOOGLE_ANALYTICS_ID = "UA-29647475-1"

  $FAYE_URL = "faye-thehiloproject.herokuapp.com/faye"

  $IMPORT_JOB_COMPANY_ID = 1

  $ENABLE_LANGUAGE_LOCALIZATION = 0
end