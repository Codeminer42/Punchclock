# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = true

  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.css_compressor = nil
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'

  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_tags = [ :request_id ]
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: ENV['HOST'] }
  config.action_mailer.perform_deliveries = true

  config.action_mailer.smtp_settings = {
    address: ENV['SMTP_SERVER'],
    port: ENV['SMTP_PORT'],
    user_name: ENV['SMTP_LOGIN'],
    password: ENV['SMTP_PASSWORD'],
    authentication: :plain,
    domain: 'cm42.io'
  }

  # SSL (https://github.com/pixielabs/letsencrypt-rails-heroku)
  config.middleware.insert_before ActionDispatch::SSL, Letsencrypt::Middleware
  config.force_ssl = true

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
end
