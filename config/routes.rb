# frozen_string_literal: true
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'user/sessions' }

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
    get 'two_factor', to: 'users#two_factor'
    get 'deactivate_two_factor', to: 'users#deactivate_two_factor'
    post 'confirm_otp', to: 'users#confirm_otp'
    get 'backup_codes', to: 'users#backup_codes'
    post 'deactivate_otp', to: 'users#deactivate_otp'
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
    namespace :v1 do
      get "users" => "companies#users"
      get "offices" => "companies#offices"
      get "holidays" => "holidays#holidays_dashboard"
      get "punches" => "punches#index"
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_scope :user do
    post 'questionnaires_kinds', to: 'evaluations#show_questionnaire_kinds', as: :show_questionnaire_kinds
    resources :evaluations, only: %i[show index]
    get "users/:user_id/notes/new" => "notes#new", as: :new_users_note
    post "users/:user_id/notes" => "notes#create", as: :user_notes
  end

  resources :questionnaires do
    resources :evaluations, only: %i[new create] do
      post :confirm, on: :collection
    end
  end

  match "*path", to: redirect("/404"), via: :all
end
