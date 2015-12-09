Rails.application.routes.draw do
  apipie
  resources :coupons, only: [:index]

  namespace :api do
    resources :products, only: [:index]
    resources :categories, only: [:index]
    resources :restaurants, only: [:index]
    get '/dictionaries' => '/api/dictionaries#index'
  end

  mount Ckeditor::Engine => '/ckeditor'
  resources :credit_cards, only: [:create]
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
  resources :locations, :only => :show
  resources :account_transactions, :only => :index

  get '/users/confirm_phone' => 'phone_number_confirmation#confirmation_form', :as => :confirmation_form
  post '/users/change_phone' => 'phone_number_confirmation#change_phone', :as => :change_phone
  post '/users/confirm_code' => 'phone_number_confirmation#confirm_code', :as => :confirm_code
  post '/users/send_code_again' => 'phone_number_confirmation#send_code_again', :as => :send_code_again
  devise_for :users, :controllers => { sessions: 'sessions', registrations: 'registrations', :omniauth_callbacks => "omniauth_callbacks" }
  devise_for :admin_users

  namespace :admin do
    get '/' => 'dashboard#index', as: :dashboard
    get '/dashboard/ga' => 'dashboard#ga'
    get '/seo' => 'settings#seo', as: :seo
    post '/seo' => 'settings#save_seo'
    get '/settings' => 'settings#index'
    post '/settings' => 'settings#save', as: :save_settings
    get '/products/import' => 'products#import', as: :products_import
    post '/products/import' => 'products#do_import', as: :products_do_import
    resources :products, except: [:show]
    resources :users, except: [:show]
    resources :admin_users, except: [:show]
    resources :restaurant_types, except: [:show]
    resources :categories, except: [:show]
    resources :locations, except: [:show]
    resources :text_pages, except: [:show]
    resources :coupons, except: [:show]
    resources :restaurants, except: [:show]
    resources :orders, except: [:show]
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
