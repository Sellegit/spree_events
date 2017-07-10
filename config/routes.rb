Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :events do
      collection do
        post :update_positions
      end
      resources :event_products do
        collection do
          post :update_positions
        end
      end
    end 
  end

  namespace :api do
    namespace :v1 do
      resources :events, only: [:index, :show], defaults: {format: :json} do
        get 'popular_events' => 'events#popular_events', on: :collection
      end
    end
  end
end
