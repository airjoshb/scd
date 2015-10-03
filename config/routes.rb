Rails.application.routes.draw do
  get 'visitors/index'

  resources :users do
    put 'add_tag/:tag', to: 'users#add_tag', as: :add_tag, on: :member
    put 'remove_tag/:tag', to: 'users#remove_tag', as: :remove_tag, on: :member
  end

  resources :share_emails

  resources :articles, :path => "/lineup" , :except => [:new, :create, :edit, :update, :destroy] do
    resources :events
    resources :locations
    put :recommend, on: :member
    put :unrecommend, on: :member
    get 'change_status/:status', to: 'articles#change_status', as: :change_status, on: :member
  end

  get 'tagged' => 'articles#tagged', :as => 'tagged'

  mount StripeEvent::Engine => '/stripe'

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup


  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords", omniauth_callbacks: 'omniauth_callbacks'}, skip: [:sessions, :registrations]

  #->Prelang (user_login:devise/stylized_paths)
  devise_scope :user do
    root to: 'users/registrations#new'
    get 'admin/users/:id', to: 'admin/users#edit', as: :edit_admin_user
    put 'admin/users/:id', to: 'admin/users#update'
    get 'admin/users', to: 'admin/users#new', as: :new_admin_user
    get    "login"   => "users/sessions#new",         as: :new_user_session
    post   "login"   => "users/sessions#create",      as: :user_session
    delete "signout" => "users/sessions#destroy",     as: :destroy_user_session

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
    patch 'article', to: 'articles#update'
    put 'article', to: 'articles#update'
    delete 'articles/:id', to: 'articles#delete', as: :delete_article
  end


  # mount using default path: /email_processor
  mount_griddler


end
