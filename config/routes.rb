Rails.application.routes.draw do
  get "session/new", to: "sessions#new", as: :new_session
  post "session", to: "sessions#create"
  delete "session", to: "sessions#destroy"

  resources :activities
  resources :messages
  resources :posts
  resources :stats
  resources :topics
  resources :users do
    get :stats
  end

  root "topics#index"
end
