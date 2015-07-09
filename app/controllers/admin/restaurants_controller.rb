class Admin::RestaurantsController < ApplicationController
  before_action :authorize_owner
  
  def show
    @restaurant = current_restaurant
  end
  
  def edit
    @restaurant = current_restaurant
  end
  
private
  def current_restaurant
    current_user.restaurants.find_by(slug: params[:slug])
  end
  
  def authorize_owner
    unless current_restaurant
      redirect_to root_path
    end
  end
end
