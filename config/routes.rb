Rails.application.routes.draw do
  root "movies#index"

  # Onboarding
  get "setup", to: "setup#new"
  post "setup", to: "setup#create"

  # Auth
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # User settings
  get "settings", to: "settings#show"
  patch "settings", to: "settings#update"

  # Admin settings
  get "admin", to: "admin#show"
  delete "admin/reset", to: "admin#reset", as: :admin_reset
  post "admin/load_demo", to: "admin#load_demo", as: :admin_load_demo

  resources :users
  resources :movie_nights do
    resources :invitations, only: [ :create ]
  end
  resources :invitations, only: [ :update ]

  resources :movies do
    member do
      get :conversion_status
    end
    resources :reviews, only: [ :create ]
    resources :episodes, only: [ :new, :create, :edit, :update, :destroy, :show ] do
      member do
        get :conversion_status
      end
    end
  end

  # Watch Progress endpoint
  post "watch_progress", to: "watch_progresses#update_progress", as: :update_watch_progress
  resources :watchlist_entries
  post "watchlist/add/:movie_id", to: "watchlist_entries#quick_add", as: :quick_add_watchlist
  delete "watchlist/remove/:movie_id", to: "watchlist_entries#quick_remove", as: :quick_remove_watchlist

  get "up" => "rails/health#show", as: :rails_health_check
end
