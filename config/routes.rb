Rails.application.routes.draw do
  resources :coupons

  mount Ckeditor::Engine => '/ckeditor'
  resources :credit_cards
  resources :charges, :only => [:create]
  resources :orders, :only => [:new, :create, :show, :index] do
    member do
      post 'pay', :as => :pay
    end
  end
  resources :line_items, :only => [:new, :create, :destroy] do
    get 'increase', :as => :increase
    get 'decrease', :as => :decrease
  end
  resources :restaurants, :only => :show
  resources :carts, :only => :show
  resources :locations, :only => :show
  resources :account_transactions, :only => :index

  get '/users/confirm_phone' => 'phone_number_confirmation#confirmation_form', :as => :confirmation_form
  post '/users/change_phone' => 'phone_number_confirmation#change_phone', :as => :change_phone
  post '/users/confirm_code' => 'phone_number_confirmation#confirm_code', :as => :confirm_code
  post '/users/send_code_again' => 'phone_number_confirmation#send_code_again', :as => :send_code_again
  devise_for :users, :controllers => { sessions: 'sessions', registrations: 'registrations', :omniauth_callbacks => "omniauth_callbacks" }
  devise_for :admin_users

  namespace :admin do
    resources :users
  end

  devise_scope :user do
    get '/users/auth/stripe_connect/callback' => 'omniauth_callbacks#stripe_connect'
    post '/users/auth/stripe_connect/callback' => 'omniauth_callbacks#stripe_connect'
  end
  get '/account' => 'welcome#account', :as => :account
  get '/referral' => 'referral#index', :as => :referral
  post '/referral/invite' => 'referral#invite', :as => :referral_invite
  get '/sitemap' => 'welcome#sitemap', :as => :sitemap

  root 'locations#index'

  match "*url", :to => "text_pages#show", :via => [:get]
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
