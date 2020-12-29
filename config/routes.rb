Rails.application.routes.draw do
  resources :members
  resources :friendships, only: [:new, :create, :destroy]

  root to: "members#index"
end
