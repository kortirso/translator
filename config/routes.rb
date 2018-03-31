Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  require 'sidekiq/web'
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) & ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
    end
  end
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, skip: %i[session registration], controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  localized do
    get 'omniauth/:provider' => 'users/omniauth#localized', as: :localized_omniauth
    devise_for :users, skip: :omniauth_callbacks, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

    resources :tasks, only: %i[index show create update destroy]
    resources :translations, only: %i[index]

    namespace :api do
      namespace :v1 do
        resources :translations, only: %i[index update]
        resources :locales, only: %i[index]
      end
    end

    root to: 'welcome#index'
  end

  match '*path', to: 'application#catch_404', via: :all
end
