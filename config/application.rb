# frozen_string_literal: true
require_relative 'boot'

require 'csv'
require "rails"
# Pick the frameworks you want:
require 'active_model/railtie'
require "active_record/railtie"
require "action_controller/railtie"
require 'action_view/railtie'
require "action_mailer/railtie"
require "sprockets/railtie"
require 'active_job/railtie'
require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Punchclock
  class Application < Rails::Application
    config.autoload_paths << "#{Rails.root}/lib"
    config.eager_load_paths << "#{Rails.root}/lib"

    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s
    ]

    config.i18n.enforce_available_locales = false
    config.i18n.locale = :'pt-BR'
    config.i18n.default_locale = :'pt-BR'
    config.time_zone = 'America/Sao_Paulo'
    config.beginning_of_week = :sunday

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_job.queue_adapter = :sidekiq

    config.active_record.legacy_connection_handling = false

    config.load_defaults 7.0
    config.generators.system_tests = nil

    config.to_prepare do
      Devise::SessionsController.layout "redesign"
      Devise::PasswordsController.layout "redesign"
      Devise::ConfirmationsController.layout "redesign"
    end
  end
end
