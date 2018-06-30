ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'sidekiq/testing'
require 'webmock/rspec'
require 'capybara/rails'
require 'capybara/rspec'

Sidekiq::Testing.fake!

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include OmniauthMacros, type: :controller
  config.include Capybara::DSL

  config.extend ControllerMacros, type: :controller

  include Warden::Test::Helpers
  Warden.test_mode!

  config.after :each do
    Warden.test_reset!
  end

  config.before :all do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
