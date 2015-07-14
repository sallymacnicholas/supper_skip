class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    if session[:admin]
      @current_user ||= Admin.find(session[:user_id]) if session[:user_id]
    else
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

  def restaurant_dropdown
    @restaurants = Restaurant.all
  end
  
  helper_method :current_user, :restaurant_dropdown

  private

  def set_cart
    @cart = Cart.new(session[:cart])
  end
  before_action :set_cart

  def authorize
    redirect_to root_path if current_user.nil? || !current_user.admin?
  end
  helper_method :authorize
end
