Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products, only: [:index, :show, :update, :create] do
    post :add_to_stock, on: :member
    get :logs, on: :collection
  end

  resources :providers, only: [:index, :update] do
    get :logs, on: :collection
  end

  resources :services, only: [:index, :update, :create, :destroy] do
    get :logs, on: :collection
  end

  resources :purchase_orders, only: [:index, :show] do
    get :logs, on: :collection
  end

  resources :sales, only: [:index, :show, :create, :earnings]

  resources :users, only: [:index, :show, :create, :update] do
    get :logs, on: :collection
  end

  post 'user_token' => 'user_token#create'

end
