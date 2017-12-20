source 'https://rubygems.org'

ruby '2.4.2'

gem 'rails', '~> 4.2.8'
gem 'pg'
gem 'unicorn'
gem 'sprockets', '2.11.0'
gem 'cancancan'
gem 'carrierwave'
gem 'devise'
gem 'dotenv-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails'
gem 'simple_form', '3.5.0'
gem 'uglifier'
gem 'activeadmin', '1.0.0pre2'
gem 'draper'
gem 'rails-i18n'
gem 'webpack-rails'
gem 'holidays', '5.6.0'

gem 'sidekiq'

gem 'rollbar'

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
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'certified'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'quiet_assets'
  gem 'foreman'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-remote', '~> 0.1.8'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'passenger', '>= 4.0.17'
end

