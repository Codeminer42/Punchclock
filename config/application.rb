require_relative 'boot'
require 'csv'

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Punchclock
  class Application < Rails::Application
    config.autoload_paths += Dir[
        "#{Rails.root}/lib"
    ]
    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s
    ]

    config.eager_load_paths << "#{Rails.root}/lib"
    config.load_defaults 5.1
    config.i18n.enforce_available_locales = false
    config.i18n.locale = :'pt-BR'
    config.i18n.default_locale = :'pt-BR'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_job.queue_adapter = :sidekiq
  end
end
