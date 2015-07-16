Rails.application.routes.draw do
  root to: "homepage#index"
  resources :users, only: [:new, :create]

  get "/login"  => "sessions#new"
  post "/login"  => "sessions#create"
  delete "/logout" => "sessions#destroy"
  get "/login_for_cart" => "sessions#new"
  get "/checkout_after_login" => "orders#create"

  get "/admin" => "admin#index"

  get "/cart" => "cart_items#index"
  post "/cart" => "cart_items#create"
  post "/remove_item" => "cart_items#destroy"
  post "/update_item" => "cart_items#update"

  resources :categories, only: [:show]
  resources :orders, only: [:new, :create, :destroy]
  get "/orders" => "user_transactions#index", as: "user_orders"
  get "/orders/:id" => "user_transactions#show", as: "user_order"

  namespace :admin do
    get "/users" => "users#index"
    get "/users/:id" => "users#show", as: "show_user"
    resources :restaurants, only: [:show, :edit, :update], param: :slug do
      resources :categories, controller: "restaurant_categories"
      resources :items, controller: "restaurant_items"
      resources :user_restaurant_roles, only: [:index, :create, :new], controller: "user_restaurant_roles"
      post "/orders/:status" => "orders#filter", as: "filter_order"
      put "/orders/:id" => "orders#update", as: "update_order"
      get "/orders/:status" => "orders#filter", as: "order"
    end
  end

  resources :restaurants, only: [:new, :create, :show], param: :slug do
    resources :items, only: [:show]
  end

  get "*rest" => "homepage#not_found"
end
