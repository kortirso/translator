Rails.application.routes.draw do
    resources :translations, only: :index
    resources :tasks, only: :create
    root to: 'translations#index'
    match "*path", to: "application#catch_404", via: :all
end
