source 'https://rubygems.org'

ruby '2.4.2'

gem 'rails', '~> 4.2.8'
gem 'pg'
gem 'unicorn'
gem 'sass', '~> 3.4.0'
gem 'sprockets', '2.11.0'
gem 'bootstrap-sass'
gem 'cancancan'
gem 'carrierwave'
gem 'coffee-rails'
gem 'devise'
gem 'devise_invitable'
gem 'dotenv-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'nested_form'
gem 'omniauth'
gem 'omniauth-google-apps'
gem 'reform'
gem 'sass-rails'
gem 'settingslogic'
gem 'simple_form', '3.5.0'
gem 'uglifier'
gem 'activeadmin', '1.0.0pre2'
gem 'draper'
gem 'rails-i18n'
gem 'responders'
gem 'webpack-rails'
gem 'kaminari', '0.17.0'
gem 'holidays', '5.6.0'

gem 'sidekiq'
gem 'clockwork', '~> 1.0.0'

gem 'bourbon'
gem 'neat'
gem 'bitters', github: 'thoughtbot/bitters'
gem 'refills', github: 'thoughtbot/refills'

# SSL (https://github.com/pixielabs/letsencrypt-rails-heroku)
gem 'platform-api', github: 'jalada/platform-api', branch: 'master'
gem 'letsencrypt-rails-heroku', group: 'production'

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'simplecov', '0.14.1', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
  gem 'capybara-selenium'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'therubyracer', '0.12.3'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'certified'
  gem 'guard'
  gem 'guard-rspec'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'rb-inotify', :require => false
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'forgery'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-remote', '~> 0.1.8'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'passenger', '>= 4.0.17'
end

gem 'foreman'
