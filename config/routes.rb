Punchclock::Application.routes.draw do
  resources :punches
  post 'punches/import_csv'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    registrations: 'users/registrations', invitations: 'users/invitations'
  }

  resources :punches
  resources :periods, only: [:index, :show]
  resources :users, except: [:new, :create]
  resources :projects, except: [:show]
  resources :company, only: [:edit, :update]
  resources :notification, only: [:index, :update]
  resources :dashboard, only: [:index] do
    get :sheets, on: :collection
    post :sheets, action: :save, on: :collection
    get '(/:year)(/:month)', action: :index, on: :collection
  end

  authenticated :user do
    root to: 'punches#index', as: :authenticated_user
  end

  authenticated :admin_user do
    root to: 'admin/admin_users#index', as: :authenticated_super
  end

  unauthenticated :user do
    root to: 'home#index'
  end

  match 'users/account/password/edit', to: 'passwords#edit', via: :get
  match(
    'users/account/password/update',
    to: 'passwords#update',
    via: [:patch, :put]
  )

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
