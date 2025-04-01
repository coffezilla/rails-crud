Rails.application.routes.draw do

  # /users/login
  # resources :users, only: [:create, :index, :show, :update, :destroy] do
  #   collection do
  #     post :login
  #   end
  # end

  # /login
  # post 'users', to: 'users#create'
  # get 'users', to: 'users#index'
  # get 'users/:id', to: 'users#show'
  # patch 'users/:id', to: 'users#update'
  # delete 'users/:id', to: 'users#destroy'  
  resources :users, only: [:create, :index, :show, :update, :destroy]
  post 'login', to: 'users#login'
  post 'refresh_token', to: 'users#refresh_token'

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "users#index"  # Change this to the appropriate controller/action
end