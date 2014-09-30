require 'sidekiq/web'
require 'admin_constraint'

PlayhardCore::Application.routes.draw do
  get '/sign_in' => 'application#sign_in'
  get 'sessions/create'
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create' #Stub
  get '/auth/failure', to: 'sessions#failure'
  get '/signout', to: 'sessions#destroy', as: :signout

  resources :games do
    member do
      get :take_part
      delete :unenroll
      delete :remove_player
    end
    resources :comments, except: [:index, :new]
  end

  resources :users, only: [:index, :show]

  resources :tags do
    collection do
      get 'search/:tag_id' => 'tags#search', as: :search
    end
  end

  resources :events

  namespace :admin do
    resources :games, only: [:index]
    resource :profile, only: [:edit, :update] do
      collection do
        delete :remove_account
      end
    end
    resources :users
    get 'heatmap' => 'heatmap#index', as: :heatmap
  end

  namespace :master do
    resources :games, only: [:index]
    resource :profile, only: [:edit, :update] do
      collection do
        delete :remove_account
      end
    end
    get 'heatmap' => 'heatmap#index', as: :heatmap
  end

  namespace :player do
    resources :games, only: [:index]
    resource :profile, only: [:edit, :update] do
      collection do
        delete :remove_account
      end
    end
  end

  resources :locations, only: [:index]

  root 'events#index'

  get '/about_us' => 'application#about_us'

  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

  get '*path', to: 'application#routing_error_handler'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
