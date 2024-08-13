Rails.application.routes.draw do
  devise_for :users

  root 'homes#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, param: :username do
    collection do
      get :search
    end
  end

  resources :posts, only: [:new, :create, :show, :destroy] do
    resources :reactions, only: [:create, :destroy]
    resources :images, only: :show
    member do
      get :reaction_users
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
