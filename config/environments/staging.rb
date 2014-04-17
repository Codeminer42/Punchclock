Punchclock::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'
  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    host: 'punchclock-staging.herokuapp.com'
  }
  config.action_mailer.perform_deliveries = true

  ActionMailer::Base.smtp_settings = {
    port: ENV['MAILGUN_SMTP_PORT'],
    address: ENV['MAILGUN_SMTP_SERVER'],
    user_name: ENV['MAILGUN_SMTP_LOGIN'],
    password: ENV['MAILGUN_SMTP_PASSWORD'],
    domain: 'heroku.com',
    authentication: :plain
  }
end
