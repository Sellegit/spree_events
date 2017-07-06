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
end
