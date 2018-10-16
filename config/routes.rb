Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
  devise_for :users

  resources :punches
  resource :user, only: %i[show edit update]
  resources :dashboard, only: :index do
    collection do
      get :sheets
      post :sheets, action: :save
      get '(/:year)(/:month)', action: :index
    end
  end

  authenticated :user do
    root to: 'punches#index', as: :authenticated_user
  end

  unauthenticated :user do
    root to: 'home#index'
  end

  get 'users/account/password/edit', to: 'passwords#edit'
  match(
    'users/account/password/update',
    to: 'passwords#update',
    via: [:patch, :put]
  )

  namespace :api do
    get ":company_id/users" => "companies#users"
    get ":company_id/offices" => "companies#offices"
    get "holidays" => "holidays#holidays_dashboard"
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
