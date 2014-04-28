require File.expand_path('../boot', __FILE__)
require 'csv'

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

Bundler.require(:default, Rails.env)

module Punchclock
  class Application < Rails::Application
    config.autoload_paths += Dir[
        "#{config.root}/lib"
    ]
    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s
    ]
    config.i18n.enforce_available_locales = false
    config.i18n.locale = :'pt-BR'
  end
end
