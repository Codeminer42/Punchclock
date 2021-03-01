# frozen_string_literal: true
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

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
  
  resources :repositories, only: :index do 
    collection do
      get "(/:languages)", action: :index
    end
  end
  
  authenticated :user do
    root to: 'punches#index', as: :authenticated_user
  end

  unauthenticated :user do
    devise_scope :user do
      root to: 'devise/sessions#new'
    end
  end

  get 'users/account/password/edit', to: 'passwords#edit'
  match(
    'users/account/password/update',
    to: 'passwords#update',
    via: [:patch, :put]
  )

  namespace :api do
    get "users" => "companies#users"
    get "offices" => "companies#offices"
    get "holidays" => "holidays#holidays_dashboard"
    post "open-source/contributions" => "contributions#create"
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_scope :user do
    post 'questionnaires_kinds', to: 'evaluations#show_questionnaire_kinds', as: :show_questionnaire_kinds
    resources :evaluations, only: %i[show index]
  end

  resources :questionnaires do
    resources :evaluations, only: %i[new create] do
      post :confirm, on: :collection
    end
  end
end
