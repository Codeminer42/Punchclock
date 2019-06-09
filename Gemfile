# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.2'

gem 'rails', '~> 5.2.2'

gem 'bootsnap', require: false

gem "autoprefixer-rails"
gem 'pg', "~> 0.1"
gem 'unicorn'
gem 'sprockets'
gem 'cancancan', '>= 2.2.0'
gem 'carrierwave'
gem 'devise'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails'
gem 'simple_form'
gem 'uglifier'
gem 'activeadmin'
gem 'draper'
gem 'draper-cancancan'
gem 'rails-i18n'
gem 'webpack-rails'
gem 'holidays', '5.6.0'
gem 'kaminari'
gem 'coffee-script', '~> 2.4', '>= 2.4.1'

gem 'ransack', '~> 2.1.1'

gem 'sidekiq'

gem 'rollbar'

gem 'bourbon', "~> 4.3"
gem 'neat', '1.7.2'
gem 'bitters', '1.1.0'
gem 'refills', '0.1.0'

# MinerCamp
gem 'normalize-rails', '~> 4.1.1'
gem 'validates_timeliness', '~> 5.0.0.alpha3'
gem 'enumerize', '~> 2.2.2'
gem 'jquery_mask_rails', '~> 0.1.0'
gem 'active_admin_theme'
gem 'font-awesome-sass', '~> 5.8.1'
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-easing-rails'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'active_skin'
gem 'active_admin_flat_skin'




# SSL (https://github.com/pixielabs/letsencrypt-rails-heroku)
gem 'platform-api', github: 'heroku/platform-api'
gem 'letsencrypt-rails-heroku', group: 'production'

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
  gem 'capybara-selenium'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'rails-controller-testing'
  gem 'capybara-screenshot'
  gem 'webdrivers', '~> 3.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'certified'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'foreman'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-remote', '~> 0.1.8'
  gem 'dotenv-rails', '~> 2.2.1'
  gem 'rubocop', require: false
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'passenger', '>= 4.0.17'
end
