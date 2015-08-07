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
    get '/' => 'dashboard#index'
    get '/settings' => 'settings#index'
    post '/settings' => 'settings#save', as: :save_settings
    get '/products/import' => 'products#import', as: :products_import
    post '/products/import' => 'products#do_import', as: :products_do_import
    resources :products
    resources :users
    resources :admin_users
    resources :restaurant_types
    resources :categories
    resources :locations
    resources :text_pages
    resources :coupons
    resources :restaurants
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
end
