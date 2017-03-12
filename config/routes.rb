Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products, only: [:index, :show, :update]
  resources :providers, only: [:index, :update, :destroy]
  resources :sales, only: [:index, :show, :create]
  resources :services, only: [:index, :create, :destroy]
  resources :purchase_orders, only: [:index, :show, :create]
end
