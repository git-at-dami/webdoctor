# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.4'

gem 'bootsnap', require: false
gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem.git', branch: 'main'
gem 'dartsass-rails'
gem 'importmap-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'propshaft'
gem 'puma'
gem 'rails', '~> 7.1'
gem 'sqlite3', '~> 1.4'
gem 'stimulus-rails'
gem 'turbo-rails'

# Service Objects
gem 'dry-transaction', '~> 0.16.0'

# Pagination
gem 'kaminari'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'i18n-tasks'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.0'
end

group :tools do
  gem 'brakeman', require: false
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
end

# Use Redis for Action Cable
gem 'redis', '~> 4.0'
