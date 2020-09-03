Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', controller: 'finder', action: 'show'
      end

      resources :merchants do
        resources :items, only: [:index], controller: 'merchants/items'
      end

      resources :items do
        get '/merchant', to: 'items/merchants#show', controller: 'items/merchants'
      end
    end
  end
end
