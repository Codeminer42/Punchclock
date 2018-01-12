Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_files = false
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_tags = [ :request_id ]
  config.log_formatter = ::Logger::Formatter.new

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: 'punchclock.cm42.io' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: '587',
    authentication: :plain,
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    domain: 'heroku.com'
  }
  # SSL (https://github.com/pixielabs/letsencrypt-rails-heroku)
  config.middleware.insert_before ActionDispatch::SSL, Letsencrypt::Middleware
  config.force_ssl = true
end
