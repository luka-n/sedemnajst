Rails.application.routes.draw do
  resources :messages
  resources :topics
  resources :users

  root "topics#index"
end
