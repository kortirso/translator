source 'https://rubygems.org'

ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.1.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'webpacker-react', '~> 0.2.0'
gem 'foreman'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'

gem 'figaro'
gem 'foundation-rails'
gem 'autoprefixer-rails', '6.7.6'
gem 'slim'
gem 'carrierwave', '~> 1.0'
gem 'sidekiq', '>= 4.2.10'
gem 'redis-namespace'
gem 'active_model_serializers', '~> 0.10.0'
gem 'oj'
gem 'oj_mimic_json'
gem 'route_translator'
gem 'devise', github: 'plataformatec/devise'
gem 'activerecord-import'
gem 'cancancan', '~> 2.0.0'

group :development do
    gem 'listen', '~> 3.0.5'
    gem 'spring'
    gem 'spring-watcher-listen', '~> 2.0.0'
    gem 'capistrano', require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano-rails', require: false
    gem 'capistrano-rvm', require: false
    gem 'capistrano-sidekiq', require: false
end

group :development, :test do
    gem 'rspec-rails'
    gem 'factory_girl_rails'
    gem 'rails-controller-testing'
end

group :test do
    gem 'shoulda-matchers'
end
