source 'https://rubygems.org'

ruby "2.1.0"

gem 'rails', '4.0.2'
gem 'pg'

gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass', branch: '3'
gem 'cancan'
gem 'carrierwave', '~> 0.9.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'devise', '>= 2.0'
gem 'devise_invitable', '~> 1.2.1'
gem 'dotenv-rails'
gem 'foreigner'
gem 'jbuilder', '~> 1.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'nested_form', '~> 0.3.2'
gem 'omniauth'
gem 'omniauth-google-apps'
gem 'reform'
gem 'sass-rails', '~> 4.0.0'
gem 'settingslogic'
gem 'simple_form'
gem 'slim'
gem 'uglifier', '>= 1.3.0'

# ActiveAdmin
# https://github.com/gregbell/active_admin/pull/2326
gem 'activeadmin', github: 'gregbell/active_admin'

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
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
  gem 'thin'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'forgery'
  gem 'rspec-rails', '~> 2.14.0'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'passenger', '>= 4.0.17'
end
