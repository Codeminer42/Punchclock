# frozen_string_literal: true
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :admin_users, ActiveAdmin::Devise.config

  get '/admin/offices/search_by_id', to: 'admin/offices#search_by_id'
  get '/admin/users/search_by_id', to: 'admin/users#search_by_id'
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

  root to: 'home#index'

  devise_scope :user do
    # get '/login', to: 'active_admin/devise/sessions#new', as: :miner_login
    post 'questionnaires_kinds', to: 'evaluations#show_questionnaire_kinds', as: :show_questionnaire_kinds
    resources :evaluations, only: %i[show index]
  end

  resources :questionnaires do
    resources :evaluations, only: %i[new create] do
      post :confirm, on: :collection
    end
  end
end
