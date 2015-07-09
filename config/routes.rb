Rails.application.routes.draw do
  root to: "static_pages#index"
  resources :users, only: [:new, :create]

  get "/login"  => "sessions#new"
  post "/login"  => "sessions#create"
  delete "/logout" => "sessions#destroy"
  get "/login_for_cart" => "sessions#new"
  get "/checkout_after_login" => "orders#create"
  get "/menu" => "items#menu"

  get "/admin" => "admin#index"

  get "/cart" => "cart_items#index"
  post "/cart" => "cart_items#create"
  post "/remove_item" => "cart_items#destroy"
  post "/update_item" => "cart_items#update"

  resources :items, only: [:show]
  resources :orders, only: [:show, :new, :create, :index]

  scope "admin", module: "admin", as: "admin" do
    post "/orders/:status" => "orders#filter", as: "filter_order"
    put "/orders/:id" => "orders#update", as: "update_order"
    get "/orders/:status" => "orders#filter", as: "order"
    get "/users" => "users#index"
    get "/users/:id" => "users#show", as: "show_user"
    resources :categories, only: [:create,
                                  :update,
                                  :edit,
                                  :destroy,
                                  :new,
                                  :index]
    resources :items, only: [:index, :new, :create, :edit, :update]
  end

  resources :restaurants, only: [:new, :create, :show], param: :slug

  get "*rest" => "static_pages#not_found"
end
