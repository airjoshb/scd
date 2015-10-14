Rails.application.routes.draw do
  get 'visitors/index'

  get '/sitemap' => 'visitors#sitemap',
      defaults: { :format => 'xml' }

  resources :share_emails

  get '/santa-cruz-restaurant-week', to: 'articles#scrw', as: :santa_cruz_restaurant_week

  resources :articles, :path => "/lineup" , :except => [:new, :create, :edit, :update, :destroy] do
    resources :events
    resources :locations
    get 'add/:article_id', to: 'articles#add', as: :add_to
    get 'remove/:item_id', to: 'articles#remove', as: :remove_from
    put :recommend, on: :member
    put :unrecommend, on: :member
    get 'change_status/:status', to: 'articles#change_status', as: :change_status, on: :member
  end

  get 'send_mail', to: 'articles#send_mail', as: :send_mail

  get 'tagged' => 'articles#tagged', :as => 'tagged'

  mount StripeEvent::Engine => '/stripe'


  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords", omniauth_callbacks: 'omniauth_callbacks'}, skip: [:sessions, :registrations]

  #->Prelang (user_login:devise/stylized_paths)
  devise_scope :user do
    root to: 'users/registrations#new'
    get 'admin/users/:id', to: 'admin/users#edit', as: :edit_admin_user
    put 'admin/users/:id', to: 'admin/users#update'
    get 'admin/users', to: 'admin/users#new', as: :new_admin_user
    put 'add_tag/:tag', to: 'users/registrations#add_tag', as: :add_tag
    put 'remove_tag/:tag', to: 'users/registrations#remove_tag', as: :remove_tag
    delete "admin/users/:id" => "admin/users#destroy", as: :delete_user_admin
    get    "login"   => "users/sessions#new",         as: :new_user_session
    post   "login"   => "users/sessions#create",      as: :user_session
    delete "signout" => "users/sessions#destroy",     as: :destroy_user_session
    match '/users/:id/finish_signup' => 'users/registrations#finish_signup', via: [:get, :patch], :as => :finish_signup


    get    "signup"  => "users/registrations#new",    as: :new_user_registration
    post   "signup"  => "users/registrations#create", as: :user_registration
    put    "signup"  => "users/registrations#update", as: :update_user_registration
    get    "account" => "users/registrations#edit",   as: :edit_user_registration
    post 'admin/add_role/:id/:role', to: 'admin/users#add_role', as: :add_role


  end

  authenticated :user do
    devise_scope :user do
      root to: 'articles#index', as: :authenticated
    end
  end

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    get 'article/:id', to: 'articles#edit', as: :edit_article
    get 'articles', to: 'articles#new', as: :new_article
    delete 'articles/:id', to: 'articles#destroy', as: :destroy_article
    put 'articles', to: 'articles#create'
    patch 'article/:id', to: 'articles#update'
    put 'article/:id', to: 'articles#update'
    delete 'articles/:id', to: 'articles#delete', as: :delete_article
  end


  # mount using default path: /email_processor
  mount_griddler


end
