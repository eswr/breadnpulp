Rails.application.routes.draw do

  root 'static_pages#home'
  get     'profile'   => 'users#show'
  get     'my_alerts' => 'users#my_alerts'
  get     'signup'    => 'users#new'
  get     'my_orders' => 'users#show_orders'

  get     'login'     => 'sessions#new'
  post    'login'     => 'sessions#create'
  delete  'logout'    => 'sessions#destroy'

  get     'new_order' => 'deliveries#new'

  get     'future_orders' => 'deliveries#future_orders'
  get     'todays_orders' => 'deliveries#todays_orders'
  get     'recent_orders' => 'deliveries#recent_orders'
  get     'chef_view'     => 'deliveries#chef_view'

  get     'foodiecalls'   => 'food_alerts#index'

  get     'assign_packs'  => 'subscriptions#assign_packs_to_subscriptions'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :addresses
  resources :food_items
  resources :food_alerts
  resources :kickerrs
  resources :menus
  resources :deliveries
  resources :subscriptions
  resources :packs,               only: [:index]

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
