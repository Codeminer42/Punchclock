Punchclock::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true

  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.after_initialize do
    Bullet.enable = ENV['BULLET_ENABLED'] == "true"
    Bullet.alert = ENV['BULLET_ALERT'] == "true"
    Bullet.bullet_logger = ENV['BULLET_LOGGER'] == "true"
    Bullet.console = ENV['BULLET_CONSOLE'] == "true"
    Bullet.rails_logger = ENV['BULLET_RAILS_LOGGER'] == "true"
    Bullet.add_footer = ENV['BULLET_ADD_FOOTER'] == "true"
  end
end
