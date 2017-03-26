Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products, only: [:index, :show, :update, :logs]
  resources :providers, only: [:index, :update, :destroy, :logs]
  resources :services, only: [:index, :create, :destroy, :logs]
  resources :purchase_orders, only: [:index, :show, :create, :logs]
  resources :sales, only: [:index, :show, :create, :earnings]
  resources :users, only: [:index, :show, :create, :update, :logs]

  post 'user_token' => 'user_token#create'

end
