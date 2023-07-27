# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'

  get '/admin/vacations/:id/denied', to: 'admin/vacations#denied', as: :admin_vacations_denied
  get '/admin/vacations/:id/approve', to: 'admin/vacations#approve', as: :admin_vacations_approve
  get '/admin/vacations/:id/cancel', to: 'admin/vacations#cancel', as: :admin_vacations_cancel

  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'user/sessions' }

  resources :punches
  resource :user, only: %i[show edit update]

  resources :vacations, only: %i[index show new create destroy] if ENV["ENABLE_VACATION"].present?

  resources :dashboard, only: :index do
    collection do
      get :sheets
      post :sheets, action: :save
      get '(/:year)(/:month)', action: :index
    end
  end

  namespace :new_admin do
    resources :mentorings, only: :index
    resources :evaluations, only: %i[index show]
    resources :allocation_charts, only: :index
    resources :allocations, only: %i[show update edit], as: :user_allocations
    resources :users, only: %i[show update edit], as: :admin_user
    resources :punches, only: :show, as: :user_punches
    resources :regional_holidays, except: %i[show update destroy]
    resources :regional_holidays, only: :show, as: :show_regional_holiday
    resources :regional_holidays, only: :update, as: :update_regional_holiday
    resources :regional_holidays, only: :destroy, as: :destroy_regional_holiday
  end

  resources :repositories, only: :index do
    get "(/:languages)", action: :index, on: :collection
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
      get 'latest_contributions' => 'contributions#latest'
      get "holidays" => "holidays#holidays_dashboard"
      post "request" => "token#request_token"
      post "refresh" => "token#refresh_token"

      resources :punches, only: %i[index show bulk] do
        post :bulk, on: :collection
      end
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_scope :user do
    post 'questionnaires_kinds', to: 'evaluations#show_questionnaire_kinds', as: :show_questionnaire_kinds
    resources :evaluations, only: %i[show index]
    resources :contributions, only: %i[index edit update]
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
