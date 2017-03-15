Rails.application.routes.draw do
    root to: 'translations#index'
    match "*path", to: "application#catch_404", via: :all
end
