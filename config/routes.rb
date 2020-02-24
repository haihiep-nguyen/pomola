Rails.application.routes.draw do
  resources :tracking_times
  resources :tasks do
    collection do
      post :command
    end
  end
  resources :categories
  resources :brands
  resources :users
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
