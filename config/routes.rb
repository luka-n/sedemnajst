Rails.application.routes.draw do
  get "session/new", to: "sessions#new", as: :new_session
  post "session", to: "sessions#create"
  delete "session", to: "sessions#destroy"

  resources :messages
  resources :topics
  resources :users

  root "topics#index"
end
