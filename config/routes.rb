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
  resources :momo do
    collection do
      get :send_to_momo
      get :send_to_vnpay
    end
  end
  get 'momo/ipn'
  post 'momo/ipn'
  get 'momo/return_url'
  post 'momo/return_url'
  get 'momo/handle_ipn' => "momo#handle_ipn"
  post 'momo/handle_ipn' => "momo#handle_ipn"
end
