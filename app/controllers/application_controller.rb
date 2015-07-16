class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :restaurant_dropdown

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def restaurant_dropdown
    Restaurant.all
  end

  private

  def set_cart
    @cart = Cart.new(session[:cart])
  end
  before_action :set_cart
end
