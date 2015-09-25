Rails.application.routes.draw do
  get 'visitors/index'

  resources :users do
    put 'add_tag/:tag', to: 'users#add_tag', as: :add_tag, on: :member
    put 'remove_tag/:tag', to: 'users#remove_tag', as: :remove_tag, on: :member
  end

  get 'admin', to: 'admin#dashboard'

  resources :share_emails

  resources :articles, :path => "/lineup" do
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
    get    "login"   => "users/sessions#new",         as: :new_user_session
    post   "login"   => "users/sessions#create",      as: :user_session
    delete "signout" => "users/sessions#destroy",     as: :destroy_user_session

    get    "signup"  => "users/registrations#new",    as: :new_user_registration
    post   "signup"  => "users/registrations#create", as: :user_registration
    put    "signup"  => "users/registrations#update", as: :update_user_registration
    get    "account" => "users/registrations#edit",   as: :edit_user_registration
  end

  authenticated :user do
    devise_scope :user do
      root to: 'articles#index', as: :authenticated
    end
  end

  # mount using default path: /email_processor
  mount_griddler


end
