source 'https://rubygems.org'

ruby '2.3.1'

git_source(:github) do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
    "https://github.com/#{repo_name}.git"
end

gem 'jquery-rails'
gem 'rails', '~> 5.1.1'
gem 'therubyracer', platforms: :ruby

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Add Webpack
gem 'foreman'
gem 'webpacker'
gem 'webpacker-react', '~> 0.2.0'

# Store secrets
gem 'figaro'

# Foundation for frontend
gem 'foundation-rails'

# Auto-prefixing CSS for cross-browser compat.
gem 'autoprefixer-rails', '6.7.6'

# Use Slim as the templating engine. Better than ERB
gem 'slim'

# File uploading
gem 'carrierwave', '~> 1.0'

# Background Jobs
gem 'redis-namespace'
gem 'sidekiq', '>= 4.2.10'

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

group :development, :test do
    gem 'factory_girl_rails'
    gem 'rails-controller-testing'
    gem 'rspec-rails'
end

group :test do
    gem 'json_spec'
    gem 'shoulda-matchers'
end
