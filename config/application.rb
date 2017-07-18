require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Translator
    # Translator Application
    class Application < Rails::Application
        ActiveModelSerializers.config.adapter = :json

        I18n.available_locales = %i[en ru da]
        config.i18n.default_locale = :en

        config.active_record.schema_format = :ruby
        config.generators do |g|
            g.test_framework :rspec, fixtures: true, views: false, view_specs: false, helper_specs: false,
                routing_specs: false, controller_specs: true, request_specs: false
            g.fixture_replacement :factory_girl, dir: 'spec/factories'
        end
        
        config.autoload_paths += %W[#{config.root}/app/jobs]
        config.active_job.queue_adapter = :sidekiq
    end
end
