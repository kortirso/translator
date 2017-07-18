Rails.application.routes.draw do
    require 'sidekiq/web'
    if Rails.env.production?
        Sidekiq::Web.use Rack::Auth::Basic do |username, password|
            ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) & ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
        end
    end
    mount Sidekiq::Web => '/sidekiq'

    localized do
        devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
        resources :tasks, only: %i[index show create]
        resources :users, only: %i[index show]
        resources :translations, only: %i[index create]
        resources :requests, only: :create

        get 'contribution' => 'welcome#contribution', as: :contribution

        namespace :api do
            namespace :v1 do
                resources :users, only: %i[create update destroy] do
                    get :me, on: :collection
                    get :access_token, on: :collection
                end
                resources :locales, only: %i[index]
                resources :tasks, only: %i[index destroy]
                resources :translations, only: %i[index update]
            end
        end

        root to: 'welcome#index'
    end

    match '*path', to: 'application#catch_404', via: :all
end
