# frozen_string_literal: true
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'selenium/webdriver'
require 'capybara/rails'
require 'webdrivers'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.include IntegrationHelpers, type: :feature
  config.include ActiveSupport::Testing::TimeHelpers
  config.include AbstractController::Translation

  config.filter_rails_from_backtrace!
  DatabaseCleaner.allow_remote_database_url = true

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if !driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end

    DatabaseCleaner.start
  end


  config.after do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
  DatabaseCleaner.allow_remote_database_url = true

  Capybara.javascript_driver = :chrome

  Capybara.register_driver :chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new(
      args: %w[headless no-sandbox]
    )
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
end
