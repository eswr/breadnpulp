Rails.application.routes.draw do

  root    'static_pages#home'
  get     'about_us'  => 'static_pages#about'
  get     'operator_view' => 'static_pages#operator_view'

  get     'profile'   => 'users#show'
  get     'my_alerts' => 'users#my_alerts'
  get     'signup'    => 'users#new'
  get     'my_orders' => 'users#show_orders'

  get     'login'     => 'sessions#new'
  post    'login'     => 'sessions#create'
  delete  'logout'    => 'sessions#destroy'

  get     'new_order' => 'deliveries#new'

  get     'future_orders'   => 'deliveries#future_deliveries'
  get     'todays_orders'   => 'deliveries#todays_deliveries'
  get     'recent_orders'   => 'deliveries#recent_deliveries'
  get     'chef_view'       => 'deliveries#chef_view'
  post    'chef_view'       => 'deliveries#chef_view'

  get     'confirm_order'   => 'deliveries#confirm_delivery'
  get     'cancel_order'    => 'deliveries#cancel_delivery'
  get     'despatch_order'  => 'deliveries#despatch_delivery'
  get     'return_order'    => 'deliveries#return_delivery'
  get     'deliver_order'   => 'deliveries#deliver_delivery'
  patch   'assign_rider'    => 'deliveries#assign_rider'

  get     'ftcash_payment'  => 'deliveries#ftcash_payment'

  get     'foodiecalls'   => 'food_alerts#index'

  get     'assign_packs'  => 'subscriptions#assign_packs_to_subscriptions'

  get     'raw_material_requirement' => 'menus#raw_material_requirement'
  post    'raw_material_requirement' => 'menus#raw_material_requirement'

  get      'new_despatch' => 'despatches#new'
  post     'new_despatch' => 'despatches#new'

  get      'new_drop' => 'drops#new'
  post     'new_drop' => 'drops#new'

  get      'todays_despatches' => 'despatches#index'
  post     'todays_despatches' => 'despatches#index'

  get      'roles' => 'roles#index'
  post     'roles' => 'roles#index'
  get      'remove_role' => 'roles#remove_role'

  get      'get_otp' => 'otps#new'
  post     'get_otp' => 'otps#new'
  post     'check_otp' => 'otps#create'

  get    'auth/:provider/callback' => 'sessions#create_omniauth'
  get    'auth/failure' => 'static_pages#home'

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
  resources :raw_materials
  resources :despatches
  resources :drops
  resources :coupons

  namespace :api do
    namespace :v1 do

      get   'login' => 'sessions#new'
      get   'check_otp' => 'sessions#create'

      resources :users, only: :show
    end
  end

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
