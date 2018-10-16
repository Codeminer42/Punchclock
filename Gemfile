source 'https://rubygems.org'

ruby '2.5.1'

gem 'rails', '~> 5.2.1'

gem 'bootsnap', require: false

gem "autoprefixer-rails"
gem 'pg', "~> 0.1"
gem 'unicorn'
gem 'sprockets'
gem 'cancancan', '>= 2.2.0'
gem 'carrierwave'
gem 'devise'
gem 'dotenv-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails'
gem 'simple_form'
gem 'uglifier'
gem 'activeadmin', '~> 1.3.0'
gem 'draper'
gem 'draper-cancancan'
gem 'rails-i18n'
gem 'webpack-rails'
gem 'holidays', '5.6.0'
gem 'kaminari'

gem 'sidekiq'

gem 'rollbar'

gem 'bourbon', "~> 4.3"
gem 'neat', '1.7.2'
gem 'bitters', '1.1.0'
gem 'refills', '0.1.0'

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
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'certified'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'foreman'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-remote', '~> 0.1.8'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'passenger', '>= 4.0.17'
end
