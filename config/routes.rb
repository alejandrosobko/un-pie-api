Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products, only: [:index, :show, :update] do
    get 'products/logs', :logs, on: :collection
  end

  resources :providers, only: [:index, :update, :destroy]do
    get 'providers/logs', :logs, on: :collection
  end

  resources :services, only: [:index, :create, :destroy]do
    get 'services/logs', :logs, on: :collection
  end

  resources :purchase_orders, only: [:index, :show, :create]do
    get 'purchase_orders/logs', :logs, on: :collection
  end

  resources :sales, only: [:index, :show, :create] do
    get 'sales/earnings', :earnings, on: :collection
  end

  resources :users, only: [:show, :create, :update] do
    get 'users/logs', :logs, on: :collection
  end
end
