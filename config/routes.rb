Punchclock::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  resources :punches
  resource :user, only: %i[show edit update]
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

  get 'users/account/password/edit', to: 'passwords#edit'
  match(
    'users/account/password/update',
    to: 'passwords#update',
    via: [:patch, :put]
  )

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
