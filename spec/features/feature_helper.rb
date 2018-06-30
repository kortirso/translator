require 'rails_helper'
require 'selenium/webdriver'

RSpec.configure do |config|
  Capybara.default_driver = :selenium_chrome_headless

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: { args: %w[headless disable-gpu] })
    Capybara::Selenium::Driver.new app, browser: :chrome, desired_capabilities: capabilities
  end

  Capybara.javascript_driver = :selenium_chrome_headless

  Capybara.configure do |cap_config|
    cap_config.default_max_wait_time = 10 # seconds
    cap_config.default_driver = :selenium_chrome_headless
  end

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    `bin/webpack`
    Webpacker::Manifest.load
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
