Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find_all', controller: 'finder', action: 'index'
        get '/find', controller: 'finder', action: 'show'

        get "/most_revenue", to: 'revenue#index'
        get '/:id/revenue', to: 'revenue#show'

        get "/most_items", to: 'items_sold#index'
      end

      namespace :items do
        get '/find_all', controller: 'finder', action: 'index'
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
