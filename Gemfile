source 'https://rubygems.org'

ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.0'
gem 'therubyracer', platforms: :ruby

# Use postgresql as the database for Active Record
gem 'pg', '0.21'

# Use Puma as the app server
gem 'puma', '3.10.0'

# Add Webpack
gem 'foreman'
gem 'webpacker', '3.2.1'
gem 'webpacker-react', '~> 0.3.2'

# Store secrets
gem 'figaro'

# Use Slim as the templating engine. Better than ERB
gem 'slim'

# Background Jobs
gem 'redis-namespace'
gem 'sidekiq', '5.0.5'

# Model Serializers
gem 'active_model_serializers', '~> 0.10.0'
gem 'oj'
gem 'oj_mimic_json'

# I18n
gem 'route_translator'

# Authentication
gem 'devise', github: 'plataformatec/devise'

# Add Auth through social networks
gem 'omniauth-facebook'
gem 'omniauth-github'

# Fast batch record creation (used by migration tasks)
gem 'activerecord-import'

# Code analyzation
gem 'rubocop', '~> 0.49.1', require: false

# Translator
gem 'yandex-translator-api', '1.2'

# Mailer styles
gem 'premailer-rails'

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
end
