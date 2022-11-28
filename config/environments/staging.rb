Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  config.serve_static_files = false
  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.css_compressor = nil
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'

  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: ENV['HOST'] }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    address: ENV['MAILGUN_SMTP_SERVER'],
    port: ENV['MAILGUN_SMTP_PORT'],
    user_name: ENV['MAILGUN_SMTP_LOGIN'],
    password: ENV['MAILGUN_SMTP_PASSWORD'],
    authentication: :plain,
    domain: 'sandbox03f78d3280c74977aa508779b0e29426.mailgun.org'
  }
end
