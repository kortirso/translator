Rails.application.routes.draw do
    require 'sidekiq/web'
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
    end if Rails.env.production?
    mount Sidekiq::Web => '/sidekiq'

    localized do
        devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }
        resources :tasks, only: [:index, :show, :create]
        resources :users, only: [:index, :show]
        resources :translations, only: :create

        namespace :api do
            namespace :v1 do
                resources :tasks, only: [:index, :destroy]
            end
        end

        root to: 'welcome#index'
    end

    match "*path", to: "application#catch_404", via: :all
end
