# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'rails', '~> 7.0.7'

gem 'bootsnap', require: false

gem 'activeadmin', '~> 2.13.1'
gem 'autoprefixer-rails', '~> 10.4.2.0'
gem 'cancancan', '~> 3.3.0'
gem 'carrierwave', '~> 2.2.2'
gem 'devise', '~> 4.8.1'
gem 'devise-two-factor',
    git: 'https://github.com/eoinkelly/devise-two-factor',
    branch: 'rails-7-support',
    ref: '7de6c315b507c41e6ee288ea0bdf3a070416bd17'
gem 'draper'
gem 'draper-cancancan', '~> 1.1.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'nokogiri', '~> 1.14.3'
gem 'pg', '~> 1.2'
gem 'rails-ajax_redirect'
gem 'rails-i18n'
gem 'rqrcode'
gem 'sassc-rails'
gem 'simple_form', '~> 5.1.0'
gem 'sprockets'
gem 'uglifier'
gem 'webpacker', '~> 5.1'

gem 'heroicon'

gem 'caxlsx'
gem 'caxlsx_rails'

gem 'docx'

gem 'active_model_serializers', '~> 0.10.13'
gem 'github_api', '~> 0.18.2'
gem 'httparty'
gem 'money-rails', '~> 1.12'

gem 'ransack', '~> 2.3'

gem 'sidekiq', "~> 6.5.12"

gem 'rollbar'

gem 'chartkick'

gem 'active_admin_theme'
gem 'bootstrap', '~> 4.5'
gem 'enumerize', '~> 2.5.0'
gem 'font-awesome-sass', '~> 5.13'
gem 'jquery-easing-rails'
gem 'jquery_mask_rails', '~> 0.1.0'
gem 'normalize-rails', '~> 4.1.1'
gem 'validates_timeliness', '~> 6.0.0.beta2', github: "mitsuru/validates_timeliness", branch: "rails7"

gem 'aasm', '~> 5.0', '>= 5.0.8'
gem 'active_admin_flat_skin'
gem 'active_skin'

# SSL (https://github.com/pixielabs/letsencrypt-rails-heroku)
gem 'platform-api', github: 'heroku/platform-api'

group :production, :staging do
  # Heroku Ruby Language Metrics
  gem "barnes"

  gem 'letsencrypt-rails-heroku'
end

gem 'inline_svg', '~> 1.9'
gem 'puma'
gem 'rswag-api', '~> 2.5.1'
gem 'rswag-ui', '~> 2.5.1'
gem "tailwindcss-rails", "~> 2.0"

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'capybara-selenium'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rails-controller-testing'
  gem "roo", "~> 2.9.0"
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', '~> 0.20', require: false
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'certified'
  gem 'foreman'
  gem 'guard'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.4'
  gem 'listen', '~> 3.2'
  gem 'spring', '~> 3.1.1'
  gem 'web-console', '~> 4.0'
end

group :development, :test do
  gem 'dotenv-rails', '~> 2.7'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'pry-remote', '~> 0.1.8'
  gem 'rspec-rails'
  gem 'rswag-specs', '~> 2.5.1'
  gem 'rubocop', require: false
  gem 'rubocop-faker', '~> 1.1'
end

group :development, :test, :staging do
  gem 'faker', '~> 2.14.0'
end
