# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', '~> 7.0.3.1'

gem 'bootsnap', require: false

gem 'nokogiri', '~> 1.13.2'
gem 'autoprefixer-rails', '~> 10.4.2.0'
gem 'pg', '~> 1.2'
gem 'sprockets'
gem 'cancancan', '~> 3.3.0'
gem 'carrierwave', '~> 2.2.2'
gem 'devise', '~> 4.8.1'
gem 'devise-two-factor',
  git: 'https://github.com/eoinkelly/devise-two-factor',
  branch: 'rails-7-support',
  ref: '7de6c315b507c41e6ee288ea0bdf3a070416bd17'
gem 'rqrcode'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sassc-rails'
gem 'simple_form', '~> 5.1.0'
gem 'uglifier'
gem 'activeadmin', '~> 2.13.1'
gem 'draper'
gem 'draper-cancancan', '~> 1.1.1'
gem 'rails-i18n'
gem 'webpacker', '~> 5.1'
gem 'holidays', '~> 8.3'
gem 'kaminari'
gem 'spreadsheet'
gem 'httparty'
gem 'github_api', '~> 0.18.2'
gem 'active_model_serializers', '~> 0.10.13'
gem 'money-rails', '~> 1.12'

gem 'ransack', '~> 2.3'

gem 'sidekiq'

gem 'rollbar'

gem 'chartkick'

gem 'normalize-rails', '~> 4.1.1'
gem 'validates_timeliness', '~> 6.0.0.beta2', github: "mitsuru/validates_timeliness", branch: "rails7"
gem 'enumerize', '~> 2.5.0'
gem 'jquery_mask_rails', '~> 0.1.0'
gem 'active_admin_theme'
gem 'font-awesome-sass', '~> 5.13'
gem 'bootstrap', '~> 4.5'
gem 'jquery-easing-rails'

gem 'active_skin'
gem 'active_admin_flat_skin'
gem 'aasm', '~> 5.0', '>= 5.0.8'

# SSL (https://github.com/pixielabs/letsencrypt-rails-heroku)
gem 'platform-api', github: 'heroku/platform-api'
gem 'letsencrypt-rails-heroku', group: 'production'

gem 'rswag-api', '~> 2.5.1'
gem 'rswag-ui', '~> 2.5.1'

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'simplecov', '~> 0.20', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'capybara-selenium'
  gem 'selenium-webdriver'
  gem 'rails-controller-testing'
  gem 'capybara-screenshot'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'certified'
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.4'
  gem 'foreman'
  gem 'web-console', '~> 4.0'
  gem 'listen', '~> 3.2'
  gem 'spring', '~> 3.1.1'
  gem 'guard'
  gem 'guard-livereload', '~> 2.5', require: false
end

gem 'unicorn'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker', '~> 2.14.0'
  gem 'rspec-rails'
  gem 'rswag-specs', '~> 2.5.1'
  gem 'pry-rails'
  gem 'pry-remote', '~> 0.1.8'
  gem 'dotenv-rails', '~> 2.7'
  gem 'rubocop', require: false
  gem 'rubocop-faker', '~> 1.1'
end

gem "tailwindcss-rails", "~> 2.0"
