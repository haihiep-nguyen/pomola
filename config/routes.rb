Rails.application.routes.draw do
  root to: 'home#index'
  as :user do
    get "signin" => "devise/sessions#new"
    post "signin" => "devise/sessions#create"
    delete "signout" => "devise/sessions#destroy"
  end
  devise_for :users
  resources :tracking_times
  resources :tasks do
    collection do
      post :command
    end
  end
  resources :categories
  resources :brands
  # resources :users
end
